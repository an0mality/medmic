//$(function() {
//    $('#notify_message_btn_zayavka').click(function () {
//        if ($('#notify_message_theme_id').val() != 0 || $('#notify_message_message').val() != '' || $('#notify_message_email').val() != '' || $('#notify_message_phone').val() != '') {
//            var pattern_phone = /^[0-9-( )+]{6,16}$/;
//            var pattern_email = /^[a-z0-9_-]+@[a-z0-9-\.]+\.([a-z]{2,3})?([a-z]{2,3})$/i;
//            if(pattern_phone.test($('#notify_message_phone').val())){
//                $('#notify_message_phone').css({'border' : '1px solid #569b44'});
//                if(pattern_email.test($('#notify_message_email').val())){
//                    $('#notify_message_email').css({'border' : '1px solid #569b44'});
//                    if ($('#notify_message_theme_id').val() != 0){
//                        $('#notify_message_theme_id').css({'border' : '1px solid #569b44'});
//                    }
//                    else {
//                        $('#notify_message_theme_id').css({'border' : '1px solid #ff0000'});
//                        alert('Поле темы не заполнено');
//                        return false;
//                    }
//
//                } else {
//                    $('#notify_message_email').css({'border' : '1px solid #ff0000'});
//                    alert('Поле email заполнено некорректно');
//                    return false;
//                }
//            } else {
//                $('#notify_message_phone').css({'border': '1px solid #ff0000'});
//                alert('Поле контактного телефона должно содержать минимум 6 цифр');
//                return false;
//            }
//        }
//        else {
//            alert('Заполнено верно нажмите Ок');
//            return true;
//
//        }
//
//    });
//});
//
//$(document).ready(function() {
//    $('#notify_message_theme_id option:last').remove()
//});






