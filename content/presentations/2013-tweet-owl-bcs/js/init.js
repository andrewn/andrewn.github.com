Reveal.initialize({
  controls: false,
  dependencies: [
    // Cross-browser shim that fully implements classList - https://github.com/eligrey/classList.js/
    { src: './bower_components/reveal.js/lib/js/classList.js', condition: function() { return !document.body.classList; } },

    // Interpret Markdown in <section> elements
    { src: './bower_components/reveal.js/plugin/markdown/marked.js', condition: function() { return !!document.querySelector( '[data-markdown]' ); } },
    { src: './bower_components/reveal.js/plugin/markdown/markdown.js', condition: function() { return !!document.querySelector( '[data-markdown]' ); } },

    // Syntax highlight for <code> elements
    { src: './bower_components/reveal.js/plugin/highlight/highlight.js', async: true, callback: function() { hljs.initHighlightingOnLoad(); } },

    // Zoom in and out with Alt+click
    // { src: './bower_components/reveal.js/plugin/zoom-js/zoom.js', async: true, condition: function() { return !!document.body.classList; } },

    // Speaker notes
    // { src: './bower_components/reveal.js/plugin/notes/notes.js', async: true, condition: function() { return !!document.body.classList; } },

    // Remote control your reveal.js presentation using a touch device
    // { src: './bower_components/reveal.js/plugin/remotes/remotes.js', async: true, condition: function() { return !!document.body.classList; } },

    // MathJax
    // { src: './bower_components/reveal.js/plugin/math/math.js', async: true }
]
});

Reveal.addEventListener( 'ready', function( event ) {
    // event.currentSlide, event.indexh, event.indexv
    window.video.initClickToPlay();
} );

function qa(sel, root) {
    return (root ? root : document).querySelectorAll(sel);
}

function q(sel, root) {
    return (root ? root : document).querySelector(sel);
}

function svg() {
    return q('svg', q('object').contentDocument);
}

Reveal.addEventListener( 'fragmentshown', function( event ) {
    var fragment = event.fragment,
        action = fragment.getAttribute('data-action-next');
    svg().className += svg().id = action;
} );

Reveal.addEventListener( 'fragmenthidden', function( event ) {
    var fragment = event.fragment,
        action = fragment.getAttribute('data-action-previous');
    svg().className += svg().id = action;
} );
