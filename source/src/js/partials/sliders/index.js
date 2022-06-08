import Swiper, {Navigation, Pagination} from "swiper";

export default ()=> {
    Swiper.use([Pagination, Navigation]);

    let catalogSwiper = new Swiper('.catalog-swiper', {
        slidesPerView: 1,
        loop: true,
        grabCursor: true,
        pagination: {
            el: '.swiper-pagination',
            type: 'bullets',
            clickable: true,
        },
        breakpoints: {
            640: {
                slidesPerView: 2,
            },
            992: {
                slidesPerView: 3,
            },
            1200: {
                slidesPerView: 4,
            },
        },
    });

    let commentSwiper = new Swiper('.comment-swiper', {
        slidesPerView: "auto",
        spaceBetween: 20,
        grabCursor: true,
        navigation: {
            nextEl: '.custom-swiper-button-next',
            prevEl: '.custom-swiper-button-prev',
        },
    });
};