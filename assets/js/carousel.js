(function(){
  
    // Create an namespace
    if ( !window.an ) { window.an = {}; }
    
    // children, parent
    dojo.require( 'dojo.NodeList-traverse' );
    
    // append()
    dojo.require( 'dojo.NodeList-manipulate' );

    // anim()
    dojo.require("dojo.NodeList-fx");

    // chain()
    dojo.require( 'dojo.fx.easing' );
    
    // Carousel widget
    var Carousel = function( el, config ) {        
                    
        var $                       = dojo.query,
            defaults                = {
                nav : ['.carousel_button'],
                easing: dojo.fx.easing.sineOut
            },
            config                  = config || {},
            animG, offsetW, offsetH = null,
            newLeft                 = 0,
            scrollAmount            = 200,
            boxMixin                = { duration: 1000 },
            contents                = $( el ).children(),
            currentItem             = 0,
            carouselScroller,
            carouselRoot,
            container,
            button;
            
        config = dojo.mixin( {}, defaults, config );

        // Work out size of single element
        var item = contents[0],
            itemW = $( item ).position()[0].w,
            itemM = $( item ).style( 'marginRight' )[0] + $( item ).style( 'marginLeft' )[0];
        
        scrollAmount = itemW + itemM;
        
        // Create carousel structure
        carouselRoot = $( 
            dojo.create( 'div', {
                className: 'carousel'
            })
        );

        container = $( el ).wrap( '<div class="container"></div>' ).parent();
        carouselRoot = container.wrap( '<div class="carousel"></div>' ).parent();
        
        buttonCore = dojo.create('span', {
            className: 'carousel_button'
        });
        
        button = dojo.create('a', {
            className: 'next'
        });
        
        $( button ).append( buttonCore );
        carouselRoot.append( button );

        // The element that moves               
        carouselScroller = $( el );

        // Connect events on load
        if ( config.nav.length == 1 ) {
            dojo.query( config.nav[0] )
                .connect( 'onclick', function ( evt ) {
                    
                    // @TODO:   Scrolling backwards and forwards should be more 
                    //          flexible and should connect more buttons.
                    // See: - http://sorgalla.com/projects/jcarousel/
                    //      
                    
                    console.log( 'current: ', currentItem );
                    
                    if ( dojo.hasClass( button, 'next' ) ) {
                        slideToItem( currentItem + config.itemsPerView );
                        $( button ).removeClass( 'next' )
                                   .addClass( 'prev' );
                    } else {
                        $( button ).removeClass( 'prev' )
                                   .addClass( 'next' );
                        slideToItem( currentItem - config.itemsPerView );
                    }
                
            });
        } else {
            throw Error('Double button nav not supported')
        }
        
        function slideToItem( index ) {
            var amount;            
            if ( contents.length > index ) {
                amount = ( scrollAmount * index );
                slideTo( -amount );
                currentItem = index;
            }
        }
              
        //sliding to the right
        function slideRight() {
            var difference = container.position()[0].w - carouselScroller.position()[0].w;
            if( newLeft > difference ) {
               slideBy( -scrollAmount );
           }
       }

        //sliding to the left
        function slideLeft() {
            if( newLeft < 0 ) {
        	    slideBy( scrollAmount );
           }
        }
        
        function slideTo( px ) {
            newLeft = px;
            carouselScroller.anim( {
        	       left: newLeft
        	   }, 
        	   boxMixin.duration/2,
        	   config.easing
            );
        }
        
        function slideBy( px ) {
            newLeft = newLeft + px;
    	    carouselScroller.anim( {
        	       left: newLeft
        	   }, 
        	   boxMixin.duration/2,
        	   config.easing);
        }
        
        return {
            slideRight  : slideRight,
            slideLeft   : slideLeft,
            slideToItem : slideToItem,
            slideTo     : slideTo,
            slideBy     : slideBy,
            contents    : contents,
            currentItem : currentItem
        }
        
    }
    
    an.Carousel = Carousel;
  
})() // end sandbox