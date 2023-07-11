
    const sidebarElementId = "#sidebar";
    const sidebarCoverElementId = "#sidebar-cover";
    const sidebarToggleElementId = "#sidebar-toggle";
    const smallDisplayWidth = "768px";
    const Animation = { open : true, close : false}

    let sidebar;

    class Sidebar {

        // ALL THE CODE NEEDED TO UNDERSTAND SIDEBAR FUNCTIONALITY

        initialize(){
            this.displayScreen.addEventListener("change", ()=>{ this.updateSidebar(); });
            this.sidebarToggleElement.addEventListener("click", ()=>{ this.toggleSideBar(); });
            this.sidebarCoverElement.addEventListener("click", ()=>{ this.closeSidebar(); });
            this.updateSidebar();
        }

        toggleSideBar() {
            if(this.sidebarIsOpen) {
                this.closeSidebar();
            } else {
                this.openSidebar();
            }
        }

        openSidebar() {
            if(this.sidebarIsOpen) return;
            this.sidebarIsOpen = true;
            this.showSidebar();
            this.updateSidebar();
        }

        closeSidebar() {
            if(this.sidebarIsNotOpen()) return;
            this.sidebarIsOpen = false;
            this.hideSidebar();
            this.updateSidebar(); 
        }

        updateSidebar() {
            if(this.Display.isSmall()) {
                if(this.sidebarIsOpen) {
                    this.showSidebarCover();
                } else {
                    this.hideSidebarCover();
                }
            } else {
                this.openSidebar();
                this.hideSidebarCover();
            }
        }

        // ALL THE CODE NEEDED TO UNDERSTAND SIDEBAR FUNCTIONALITY

        /* EXTRA CODE YOU DO NOT NEED TO KNOW, all the mess is here
                        |
                        |
                        |
                        |
                        |
                        V
        */
        constructor(sidebarElement, sidebarToggleElement, sidebarCoverElement, displayScreen) {
            this.sidebarElement = sidebarElement;
            this.sidebarToggleElement = sidebarToggleElement;
            this.sidebarCoverElement = sidebarCoverElement;
            this.displayScreen = displayScreen;
            this.sidebarIsOpen = true;
            this.Display = {
                isSmall: () => { return displayScreen.matches; }
            }
            this.initialize();
        }

        showSidebar(){
            this.sidebarElement.classList.remove("custom-sidebar-closed");
        }

        hideSidebar(){
            this.sidebarElement.classList.remove("custom-sidebar-closed");
            this.sidebarElement.classList.add("custom-sidebar-closed");
        }

        showSidebarToggle() {
            this.sidebarToggleElement.classList.remove("d-none");
        }

        hideSidebarToggle() {
            this.sidebarToggleElement.classList.remove("d-none");
            this.sidebarToggleElement.classList.add("d-none");
        }

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

    {
        const sidebarElement = document.querySelector(sidebarElementId);
        const sidebarToggleElement = document.querySelector(sidebarToggleElementId);
        const sidebarCoverElement = document.querySelector(sidebarCoverElementId);
        const windowMatchMedia = window.matchMedia(`(max-width: ${smallDisplayWidth})`);
        if(window.attachEvent) {
            document.attachEvent("DOMContentLoaded", () => { 
                sidebar = new Sidebar(sidebarElement, sidebarToggleElement, sidebarCoverElement, windowMatchMedia); 
            } );
        } else if (window.addEventListener) {
            document.addEventListener("DOMContentLoaded", () => { 
                sidebar = new Sidebar(sidebarElement, sidebarToggleElement, sidebarCoverElement, windowMatchMedia); 
            } );
        } else {
            console.error("It seems that your browser doesn't support event listeners.");
        }
    }