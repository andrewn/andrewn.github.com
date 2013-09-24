(function (exports) {

    function handleClick(evt) {
        var video = evt.target;
        video.paused ? video.play() : video.pause();
        return false;
    }

    function addClickToPlay(video) {
        video.addEventListener('click', handleClick, true);
    }

    exports.video = {};
    exports.video.initClickToPlay = function () {
        var videos = document.querySelectorAll('video');
        [].forEach.call(videos, addClickToPlay);
    };

})(window);