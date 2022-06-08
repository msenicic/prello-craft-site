// Styles
import '../scss/main.scss';

// Import asset images
import './images';

// Import javascript
// import debounce from './helpers/debounce';

import sliders from "./partials/sliders";

import navToggle from "./partials/navToggle";

import cssVars from 'css-vars-ponyfill';

document.addEventListener("DOMContentLoaded", function () {
    cssVars({});

    sliders();

    navToggle();

    window.addEventListener('resize', function () {
        document.documentElement.style.setProperty('--vh', window.innerHeight * 0.01 + 'px');
    });
});