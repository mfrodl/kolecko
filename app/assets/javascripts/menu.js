$(document).on('turbolinks:load', function() {
  var Menu = function(element) {
    this.element = element;

    var menuItem = $('.menu-item', this.element);
    menuItem.click(function() {
      $(this).toggleClass('open');
      $(this).next().slideToggle();
    });
  };

  var menu = Menu($('.main-menu'));

  var toggleMenu = function() {
    $('.menu').toggleClass('open closed');
    $('.hamburger').toggleClass('fa-bars fa-arrow-left');
  };

  $('.hamburger').click(toggleMenu);
});
