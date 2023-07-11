const sidebarElement = document.querySelector("#sidebar");
const sidebarCoverElement = document.querySelector("#sidebar-cover");
const windowMatchMedia = window.matchMedia("(max-width: 768px)");
const display = {
    isSmall: () => { return windowMatchMedia.matches; }
}
let sidebar;

class Sidebar {
    constructor(sidebarElement, sidebarCoverElement) {
        this.sidebarElement = sidebarElement;
        this.sidebarCoverElement = sidebarCoverElement;
        this.sidebarIsOpen = true;
        this.initialize();
    }

    // ALL THE CODE NEEDED TO UNDERSTAND SIDEBAR FUNCTIONALITY

    initialize(){
        windowMatchMedia.addEventListener("change", ()=>{ this.updateSidebar(); });
        this.sidebarCoverElement.addEventListener("click", ()=>{ this.closeSidebar(); });
        this.updateSidebar();
    }

    openSidebar() {
        if(this.sidebarIsOpen) return;
        this.sidebarIsOpen = true;

        // animate the sidebar opening

        this.updateSidebar();
    }

    closeSidebar() {
        if(this.sidebarIsNotOpen()) return;
        this.sidebarIsOpen = false;

        // animate the sidebar closing
        this.updateSidebar();
    }

    updateSidebar() {
        if(display.isSmall() && this.sidebarIsOpen) {
            this.showSidebarCover();
        } else {
            this.hideSidebarCover();
        }
    }

    // ALL THE CODE NEEDED TO UNDERSTAND SIDEBAR FUNCTIONALITY

    /* EXTRA CODE YOU DO NOT NEED TO KNOW
                    |
                    |
                    |
                    |
                    |
                    V
    */

    showSidebarCover(){
        this.sidebarCoverElement.classList.remove("d-none");
    }

    hideSidebarCover(){
        this.sidebarCoverElement.classList.remove("d-none");
        this.sidebarCoverElement.classList.add("d-none");
    }

    sidebarIsNotOpen() {
        return !this.sidebarIsOpen;
    }
}

if(window.attachEvent) {
    document.attachEvent("DOMContentLoaded", () => { sidebar = new Sidebar(sidebarElement, sidebarCoverElement); } );
} else if (window.addEventListener) {
    document.addEventListener("DOMContentLoaded", () => { sidebar = new Sidebar(sidebarElement, sidebarCoverElement); } );
} else {
    console.error("It seems that your browser doesn't support event listeners.");
}
