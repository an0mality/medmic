$(document).ready(function() {
    $('#analysis_last_menstruation_date').datetimepicker({
        language: 'ru',
        format: 'DD/MM/YYYY'});

    function update_diagn(){
        if ($('#mkb_handbook_code').val() != []){
            var diagnostic_first = $('#mkb_handbook_code').val();
            $.ajax({
                url:  "/vpch/analyses/update_diagnostic_first",
                dataType: "script",
                data:{
                    id: diagnostic_first
                },
                error: function(){
                    $('#diagnostic_first').text('Описание для данного кода не найдено');}
            });
        }
        else
        { $('#diagnostic_first').text('Укажите код по МКБ-10 чтобы увидеть описание диагноза');
        };
    };

    $('#mkb_handbook_code').on('click', function(){
        update_diagn();
    });
    $('#mkb_handbook_code').on('keyup', function(){
        update_diagn();
    });
    $('#mkb_handbook_code').on('change', function(){
        update_diagn();
    });

    $('.form_first').on('submit', function(){
        if (confirm('Вывести направление на печать?')){
            if ($('#mkb_handbook_code').val()=='' ){
                alert('Заполните поля диагноза');
                return false;}
            else if ($('#scraping').val()== 0){
                alert("Заполните поле 'Соскоб получен'");
                return false;}
            else if ($('#last_menstruation_date').val()=='' && $('#menopause').val()=='' ){
                alert("Заполните поле даты последней менструации или срока менопаузы");
                return false;}
            else {
                return true;
            }
        }
        else {
            return false;
        }
    })
});
