const options = {
    root: document.querySelector('#intersection'),
    rootMargin: '0px',
    threshold: 0.5
}

const observer = new IntersectionObserver(() => {
    console.log('IntersectionObserver');
}, options);