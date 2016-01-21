// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery.min.js
//= require jquery_ujs
//=  require bootstrap


$(document).ready(function(){
    var notification = $('#notice').text().trim();
    if(notification.length > 0){
        $.notify({
            // options
            icon: 'fa fa-bolt',
            //title: 'Bootstrap notify',
            message: notification
        },{
            // settings
            element: 'body',
            type: "success",
            placement: {
                from: "top",
                align: "center"
            },
            offset: 20,
            spacing: 10,
            z_index: 1031,
            delay: 2000,
            timer: 1000,
            mouse_over: null,
            animate: {
                enter: 'animated fadeInDown',
                exit: 'animated fadeOutUp'
            },
            icon_type: 'class'
        });
    }
});