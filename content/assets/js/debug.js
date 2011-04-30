(function() {
    
    var DEBUG_MODE  = 'debug',
        DEBUG_CLASS = 'debug';

    function isDebug() {
        return (new RegExp(DEBUG_MODE)).test(location.search);
    }

    function enableGrid() {
        document.body.className += DEBUG_CLASS;
    }

    function init() {
        if ( isDebug() ) {
            enableGrid();
        }
    }

    init();
})();