export default ()=> {
    var bar = document.querySelector('.fa-bars');
    var list = document.querySelector('.site-nav');
    var header = document.querySelector('header');

    bar.addEventListener("click", function() {
        if(header.classList.contains("active") && window.scrollY > 0) {
            list.classList.toggle("active");
        }
        else {
            header.classList.toggle('active');
            list.classList.toggle("active");
        }
    });

    window.addEventListener("resize", function() {
        if (window.innerWidth > 992) {
            list.classList.remove("active");
        }
        if (list.classList.contains("active") && window.scrollY == 0) {
            header.classList.remove('active');
            list.classList.remove('active');
        }
        else if(list.classList.contains("active") && window.scrollY > 0) {
            list.classList.remove('active');
        }
    });

    window.addEventListener("scroll", function() {
        list.classList.remove("active");

        if(window.scrollY > 0){
            header.classList.add('active');
        }else{
            header.classList.remove('active');
        }
    });

    window.addEventListener("load", function() {
        if(window.scrollY > 0){
            header.classList.add('active');
        }else{
            header.classList.remove('active');
        }
    });
};