// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//= require jquery3
//= require popper
//= require bootstrap-sprockets
//= require jquery.raty.js
//= require cocoon

//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .

// ページの一番上に遷移
$(document).on('turbolinks:load', function() {
  $('#back a').on('click',function(event){
    $('body, html').animate({
      scrollTop:0
    }, 800);
    event.preventDefault();
  });
});

// ハンバーガーメニュー
$(document).on('turbolinks:load', function() {
  $('.navbar-toggler').on('click', function(event) {
    // クリックされた時していののクラスに'active'を追加する
    // これによりCSSが反映される
    // toggleClass class属性の追加と削除を交互に行う
    $('.navbar-toggler-icon').toggleClass('active');
  });
});

