$(document).ready(function() {
    $(".spinner").hide();

    $('.add_to_exist_reg').on('click', function(){
        var patient_id = $(this).closest('tr');
        var reg_id = $(this).prev();
        if ($(reg_id).val() != ''){
            if (confirm('Добавить пациента ' + ' '+ $(patient_id).attr('name')+ ' '+ 'в реестр' + ' '+ $(reg_id).val()+''+'?')){

                $.ajax({
                    url: '/vpch/registries/add_to_exist_registry',
                    method: 'POST',
                    dataType: 'script',
                    data: {registry_key: $(reg_id).val(), patient_id: $(patient_id).attr('data_id')},

                });
                alert('Пациент ' + ' '+ $(patient_id).attr('name')+ ' '+ 'добавлена в реестр' + ' '+ $(reg_id).val());
                location.reload();
            }
        }
        else {alert('Укажите номер реестра')}
    });


    $('unsel_25').hide();
    var my= [];
    $('#select_25').on('click', function(){
        var m = $('#sel_for_reestr input:checkbox');

        if($(this).is(':checked')){
            //alert('checked');
            m.slice(0,25).prop('checked', true);
            $('unsel_25').show();
            $('sel_25').hide();
        }
        else{
            var t = $('#sel_for_reestr tr').length;
            m.slice(0,t).prop('checked', false);
            $('unsel_25').hide();
            $('sel_25').show();
        }
        updateArray();
    });

    $('[name=reestr]').on('click', function(){
        updateArray();
    });

    function updateArray()
    {
        my=[];
        $('[name=reestr]:checked').each(function () {
            var l = $(this).parents('tr')[0];
            my.push($(l).attr('data_id'));
        });
        $('#show').html('Вы выбрали '+ my.length+' пациентов(та)');
    };

    $('#create_reestr_btn').on('click', function(){
        if (confirm('Создать реестр из выбранных пациентов?')){
            var type_org_id = $('#type_org_id').val();
            if (my.length > 0){
                $.ajax({
                    url:  "/vpch/registries",
                    dataType: "html",
                    method:"POST",
                    data:{
                        my: my,
                        type_org: type_org_id
                    },
                    success: function (){
                        alert('Пациенты заносятся в реестр. Подождите...');
                        console.log('в реестре заносится' + ' '+ my.length+' '+'пациентов')
                        console.log('задержка 2 секунды')
                        //window.location.href ='registries';
                        setTimeout(function(){window.location.href ='/vpch/registries'}, 2000);
                        console.log('переадресация на список реестров')
                    },
                    error: function () {
                        alert('Произошла ошибка работы сервера, попробуйте еще раз');
                    }
                });
            }
            else{
                alert('Ошибка при создании реестра. Вы не выбрали ни одного пациента');
                return false;
            };
        }
        else{

            return false;
        };


    });
});
