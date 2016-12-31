var fontLoad = (function(font) {
    var link = document.createElement('link');
    link.rel = 'stylesheet';
    link.href = 'https://fonts.googleapis.com/css?family=' + font;
    document.head.appendChild(link);
})('Open+Sans:400,500');