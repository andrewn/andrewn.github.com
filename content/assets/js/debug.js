(function() {
    
    var DEBUG_MODE = 'debug';

    function isDebug() {
        return (new RegExp(DEBUG_MODE)).test(location.search);
    }

    function enableGrid() {
        document.body.className += 'grid';
    }

    function init() {
        if ( isDebug() ) {
            enableGrid();
        }
    }

    init();
})();