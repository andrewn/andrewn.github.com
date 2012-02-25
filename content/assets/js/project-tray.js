define('project-tray', [], function () {
    var Control = function (control, container, forceFixedHeight) {
        this.el = document.createElement('a');
        this.el.href = '#';

        this.container = container;

        this.el.addEventListener('click', function (event) {
            this.isOpen() ? this.close() : this.open(); 
            event.preventDefault();
        }.bind(this), false);

        if (forceFixedHeight) {
            this.restoreHeight = this.container.offsetHeight;
        }
        
        this.close();

        control.appendChild(this.el);
    }
    Control.prototype.open = function () {
        this.el.innerHTML = 'Less';
        this.container.classList.add('is-open');
        this.container.classList.remove('is-closed');
        this.container.style.height = this.restoreHeight + 'px';
    };
    Control.prototype.close = function () {
        this.el.innerHTML = 'More';
        this.container.classList.add('is-closed');
        this.container.classList.remove('is-open');
        this.container.style.height = null;
    };
    Control.prototype.isOpen = function () {
        return this.container.classList.contains('is-open');
    };

    return function (controlSel, containerSel, forceFixedHeight) {
        var controlEl   = document.querySelector(controlSel),
            containerEl = document.querySelector(containerSel),
            control     = new Control(controlEl, containerEl, forceFixedHeight);
    };
});