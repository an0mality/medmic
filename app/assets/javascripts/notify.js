$(document).ready(function() {

    $('.spinner').hide();
    $('#theme_name').autocomplete({
        minLength: 1,
        source: "/notify/search_theme"
    });
    //$('#notify_message_btn_check').click(function () {
    //    var val_all = $('#notify_message_all_all:checked').val();
    //    val_feed = $('#notify_message_all_feed:checked').val();
    //    val_mse = $('#notify_message_all_mse:checked').val();
    //    val_vpch = $('#notify_message_all_vpch:checked').val();
    //    val_user = $('#notify_message_recipient_user_id').val();
    //    if (val_feed == 'feed' || val_mse == 'mse' || val_vpch == 'vpch' || val_all == 'all' || val_user >= 1) {
    //        if ($('#notify_message_begin_at').val() == '' || $('#notify_message_end_at').val() == '') {
    //            alert('Заполните все поля');
    //            return false;
    //        }
    //        else {
    //            alert('Все заполнено верно. Нажмите ОК');
    //            return true;
    //        }
    //    } else {
    //        alert('Выберите какой группе или пользователю отправить сообщение.');
    //        return false;
    //    }
    //});
    //

});


