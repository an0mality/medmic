$(document).ready(function() {
    $(".spinner").hide();
    $(document).ready(function() {
        jQuery(".best_in_place").best_in_place();
    });

    var initial_spid_cofirm_date = $('#initial_spid_cofirm_date');
    initial_spid_cofirm_date.hide();
    $('.piker').datetimepicker({
        language: 'ru',
        format: 'DD.MM.YYYY'});
    //$(".piker").val(initial_spid_cofirm_date.val());
    $('#spid_sent_date').datetimepicker({
        language: 'ru',
        format: 'DD.MM.YYYY'});


    var my_confirm = [];
    var my_print = [];
    updateArrayConfirm();
    updateFieldConfirmSpidDate();

    $('#print_button').on('click', function(){
        if (confirm('Распечатать страницу?')){
            var printing_css='<style media=print>tr:nth-child(even) td{background: #f0f0f0;}</style>';
            var html_to_print=printing_css+$('#table_result').html();
            var iframe=$('<iframe id="print_frame">');
            $('body').append(iframe);
            var doc = $('#print_frame')[0].contentDocument || $('#print_frame')[0].contentWindow.document;
            var win = $('#print_frame')[0].contentWindow || $('#print_frame')[0];
            doc.getElementsByTagName('body')[0].innerHTML=html_to_print;
            win.print();
            $('iframe').remove();
        }
    });

    $('#hide_sidebar').on('click', function(){
        $( ".ds" ).toggle();


    });

    $('#percent_progress').hide();

    $('unsel_confirm_25').hide();
    $('unsel_onko_confirm_25').hide();
    $('unsel_print_25').hide();
    $('#create_rmis_record').hide();
    $('unsel_print_25_btn').hide();

    var my= [];

    $('#confirm_25').on('click', function(){
        var m = $('#table_result [name=confirm]');
        if($(this).is(':checked')){
            m.slice(0,25).prop('checked', true);
            $('unsel_confirm_25').show();
            $('confirm_25').hide();
        }
        else{
            var t = $('#table_result tr').length;
            m.slice(0,t).prop('checked', false);
            $('unsel_confirm_25').hide();
            $('confirm_25').show();
        }
        updateArrayConfirm();
        updateAnalyses();
        updateFieldConfirmSpidDate();
    });

    $('#onko_confirm_25').on('click', function(){
        var m = $('#table_result [name=onko_confirm]');
        if($(this).is(':checked')){
            //alert('checked');
            m.slice(0,25).prop('checked', true);
            $('unsel_onko_confirm_25').show();
            $('#create_rmis_record').show();
            $('onko_confirm_25').hide();
        }
        else{
            var t = $('#table_result tr').length;
            m.slice(0,t).prop('checked', false);
            $('unsel_onko_confirm_25').hide();
            $('#create_rmis_record').hide();
            $('onko_confirm_25').show();
        }
        updateArrayOnkoConfirm();
        updateFieldConfirmSpidDate();
    });

    $('#print_25').on('click', function(){
        var m = $('#table_result [name=print]');
        if($(this).is(':checked')){
            m.slice(0,25).prop('checked', true);
            $('unsel_print_25').show();
            $('unsel_print_25_btn').show();
            $('print_25').hide();
        }
        else{
            var t = $('#table_result tr').length;
            m.slice(0,t).prop('checked', false);
            $('unsel_print_25').hide();
            $('unsel_print_25_btn').hide();
            $('print_25').show();
        }
        updateArrayPrint();
    });

    function updateArrayConfirm()
    {
        my_confirm =[];
        $('[name=confirm]:checked').each(function () {
            var l = $(this).parents('tr')[0];
            my_confirm.push($(l).attr('data_id'));
        });
        $('#show_confirm').html('Вы выбрали для одобрения '+ my_confirm.length+' пациентов(та)');
    };

    function updateArrayOnkoConfirm()
    {
        my_confirm =[];
        $('[name=onko_confirm]:checked').each(function () {
            var l = $(this).parents('tr')[0];
            my_confirm.push($(l).attr('data_id'));
        });
        $('#show_onko_confirm').html('Вы выбрали '+ my_confirm.length+' пациентов(та)');
    };

    function updateArrayPrint()
    {
        my_print =[];
        $('[name=print]:checked').each(function () {

            var l = $(this).parents('tr')[0];
            my_print.push($(l).attr('data_id'));
        });
        $('#show_print').html('Вы выбрали для печати '+ my_print.length+' пациентов(та)');
    };


    function updateFieldConfirmSpidDate(){
        var table_length = $('#table_result tr').length - 1 ;
        if (my_confirm.length == table_length ){
            $('.spid_confirm_date').show();
        }
        else{
            $('.spid_confirm_date').hide();
        }
    };

    $('[name=confirm]').on('click', function(){
        updateArrayConfirm();
        updateAnalyses();
        updateFieldConfirmSpidDate();
        if(my_confirm.length == 25 ){
            $('unsel_confirm_25').show();
            $('confirm_25').hide();
        }
        else {
            $('unsel_confirm_25').hide();
            $('confirm_25').show();
        }
    });

    $('[name=onko_confirm]').on('click', function(){
        updateArrayOnkoConfirm();
        if(my_confirm.length != 0 ){
            $('unsel_onko_confirm_25').show();
            $('onko_confirm_25').hide();
            $('#create_rmis_record').show();

        }
        else {
            $('unsel_onko_confirm_25').hide();
            $('onko_confirm_25').show();
            $('#create_rmis_record').hide();
        }
    });


    $('[name=print]').on('click', function(){

        updateArrayPrint();
        if(my_print.length > 0 && my_print.length < 25 ){
            $('unsel_print_25_btn').show();
        }
        else if (my_print.length == 25){
            $('unsel_print_25').show();
            $('print_25').hide();
        }
        else{
            $('unsel_print_25').hide();
            $('unsel_print_25_btn').hide();
            $('print_25').show();
        }
    });

    $('unsel_print_25_btn').on('click', function(){
        if ($('#recep_at').val() != ''){
            updateArrayPrint();
            printForm();
        }
        else{
            alert('Укажите дату приема материала');
            return false;
        }
    });

    $('.set_key').on('click', function(){
        if ($('#key_spid').val() == ''){
            alert('Укажите начальное значение ключа');
            return false;
        }
    });

    function updateAnalyses()
    {

        var registry_id = $('#registry_id').val();

        $.ajax({
            url:  "/vpch/result/analys_spid",
            method: 'post',
            dataType: "script",
            data:{
                id: my_confirm,
                registry_id: registry_id
            }
        });
    };


    var progress = $('.progress');
    progress.hide();
    function printForm()
    {
        var registry_id = $('#registry_id').val();
        var recep_at = $('#recep_at').val();
        var user_id = $('#user_id').val();

        progress.show();
        $.ajax({
            url:  "/vpch/result/analys_spid",
            method: 'POSt',
            data:{
                print_array: my_print,
                registry_id: registry_id,
                recep_at: recep_at,
                user_id: user_id
            },
            success: function(){
                progress.hide();
                alert('Форма результатов сформирована!');
                location.reload();
            }
        });


    };


    $('#recep_at').datetimepicker({
        language: 'ru',
        format: 'DD.MM.YYYY'});


    //var progressbar = $('.progress')
    //progressbar.hide();
    //$('.spid_confirm_date').on('click', function(){
    //    var date = $('#spid_confirm_date').val();
    //    var registry_id = $('#registry_id').val();
    //    $.ajax({
    //        url: "/vpch/result/analys_spid",
    //        method: 'post',
    //        dataType: "script",
    //        data:{ spid_confirm_date: date, registry_id: registry_id},
    //        success: function(){
    //            alert('Запись прошла успешно!');
    //        }
    //    });
    //});
});
