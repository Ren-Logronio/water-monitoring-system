const navbar = document.getElementById('navbar');
const navbarLimit = 0.5;
const scrollbarLimit = 0.25 ;
const Scrollbar = {
    hidden: '#eee',
    visible: document.documentElement.style.getPropertyValue('--scrollbar-color')
};
const options = {
    root: null,
    rootMargin: '0px',
    threshold: []
};

for (let i = 0; i <= 1.0; i += 0.01) {
    options.threshold.push(i);
}

const observer = new IntersectionObserver(
    (entries, observer) => {
        entries.forEach(entry => {
            if(entry.intersectionRatio <= navbarLimit) {
                navbar.classList.remove('navbar-topped');
                navbar.classList.add('navbar-scrolled');
            } else {
                navbar.classList.remove('navbar-scrolled');
                navbar.classList.add('navbar-topped');
            }
            if (entry.intersectionRatio > scrollbarLimit) {
                document.documentElement.style.setProperty('--scrollbar-color', Scrollbar.hidden);
            } else {
                document.documentElement.style.setProperty('--scrollbar-color', Scrollbar.visible);
            }
        });
    }, options
);
observer.observe(document.getElementById('intersection'));