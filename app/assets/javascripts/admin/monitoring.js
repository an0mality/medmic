//= require Chart.min


$(document).ready(function(){
    var counter = makeCounter();
    var text;

    var now_events_x;
    var now_events_y;
    var now_events_two_x;
    var now_events_two_y;
    var now_events_three_x;
    var now_events_three_y;
    var co_now, co_week, co_month;

    var week_events_x;
    var week_events_y;
    var week_events_two_x;
    var week_events_two_y;
    var week_events_three_x;
    var week_events_three_y;

    var month_events_x;
    var month_events_y;
    var month_events_two_x;
    var month_events_two_y;
    var month_events_three_x;
    var month_events_three_y;

    var time_now, time_week, time_month;

    var show_day=new Boolean(false);
    var show_week=new Boolean(false);
    var show_month=new Boolean(false);

    hideAll();
    init();

    function hideAll(){
        $('canvas').hide();
        $('.well').hide();
    }

    function get_data_chart(){

        var req = $.ajax({
            url: '/admin/monitoring/get_data_chart',
            method: 'POST',
            dataType: 'json',
            async: false,
            data: {
                count: counter.getValue(),
                now: Boolean(show_day),
                week: Boolean(show_week),
                month: Boolean(show_month)
            }
        });
        return req.responseText;
    };


    function appendTable(){
        var tableId = $('#table');
        //var caption$ = '<caption></caption>>';
        //var time = $('#time');
        //var label_table = time.innerHTML += 'Кол-во посещений пользователями на '+time_now;
        //var label_table =  'Кол-во посещений пользователями на '+time_now || +time_week || + time_month;
        var table$ = '<table><thead><tr><th width="40%">Организация</th><th width="40%">Пользователь</th><th width="20%">Кол-во посещений ссылок</th></tr></thead><tbody></tbody></table>';
        //time.remove();
        //time.append(label_table);

        //time.append(label_table);
        tableId.append(table$);
        $('#table>table').addClass('table table-bordered table-condensed table-striped table-hover');

    };

    function appendTd(value){
        var td$ = '<td></td>>';
        var currentTr$, currentTd$;
        currentTr$ = $('#table>table>tbody>tr:last-child');
        currentTr$.append(td$);
        currentTd$ = $('#table>table>tbody>tr:last-child>td:last-child');
        currentTd$.html(value);
    };

    function createTable(){
        var tr$ = '<tr></tr>>';
        var tableparentId = $('#table>table');
        var tableTbody$;
        var list = co_now || co_week || co_month;
        var keys = Object.keys(list);

        if (tableparentId.length==0){
            appendTable();
        }
        else{
            tableparentId.remove();
            appendTable();
        };

        tableTbody$= $('#table>table>tbody')


        if(co_now) console.log('Object.keys(co_now) '+ Object.keys(co_now));
        if(co_week)console.log('Object.keys(co_week) '+ Object.keys(co_week));
        if(co_month)console.log('Object.keys(co_month) '+ Object.keys(co_month));

        for (var i=0;i<keys.length;i++){
            tableTbody$.append(tr$);
            appendTd(keys[i]);
            appendTd(list[keys[i]][0][0]);
            appendTd(list[keys[i]][0][1]);
            for(var j=1;j<list[keys[i]].length;j++){
                tableTbody$.append(tr$);
                appendTd('');
                appendTd(list[keys[i]][j][0]);
                appendTd(list[keys[i]][j][1]);
            };
        };
    };

    //загрузка index
    function init(){

        counter.resetValue();
        show_day=Boolean(true);
        show_week=Boolean(false);
        show_month=Boolean(false);
        setVariableInitial(JSON.parse(get_data_chart()));
        createTable();
        var label_table =  'Кол-во посещений пользователями на '+time_now;
        $('#time').append(label_table);
        line_chart('myNow','line',now_events_x, 'Активность', now_events_y, 'Кол-во переходов по ссылкам на '+time_now);
        line_chart('myNowTwo','horizontalBar',now_events_two_x, 'Востребованные ссылки', now_events_two_y, 'Востребованные ссылки на '+time_now);
        line_chart('myNowThree','horizontalBar',now_events_three_x, 'Количество пользователей ', now_events_three_y, 'Кол-во пользователей от организации на '+time_now);
        $('#myNow').show();
        $('#myNowTwo').show();
        $('#myNowThree').show();
        $('.now').show();

    };

    function setVariableInitial(text){
        now_events_x = text['data']['x_cuv_now'];
        now_events_y = text['data']['y_cuv_now'];
        now_events_two_x = text['data']['x_cpv_now'];
        now_events_two_y = text['data']['y_cpv_now'];
        now_events_three_x = text['data']['x_uv_now'];
        now_events_three_y = text['data']['y_uv_now'];

        co_now = text['data']['co_now'];
        co_week = text['data']['co_week'];
        co_month = text['data']['co_month'];

        week_events_x = text['data']['x_cuv_week'];
        week_events_y = text['data']['y_cuv_week'];
        week_events_two_x = text['data']['x_cpv_week'];
        week_events_two_y = text['data']['y_cpv_week'];
        week_events_three_x = text['data']['x_uv_week'];
        week_events_three_y = text['data']['y_uv_week'];

        month_events_x = text['data']['x_cuv_month'];
        month_events_y = text['data']['y_cuv_month'];
        month_events_two_x = text['data']['x_cpv_month'];
        month_events_two_y = text['data']['y_cpv_month'];
        month_events_three_x = text['data']['x_uv_month'];
        month_events_three_y = text['data']['y_uv_month'];

        time_now = text['data']['time_now'];
        time_week = text['data']['time_week'];
        time_month = text['data']['time_month'];

        console.log('co_now '+co_now);
        console.log('co_week '+co_week);
        console.log('co_month '+co_month);


    }


    function makeCounter() {
        var currentCount = 0;
        return { // возвратим объект вместо функции
            getNext: function() {
                currentCount +=1;
                return currentCount;
            },
            getBack: function(){
                currentCount -=1;
                return currentCount;
            },
            getValue: function(){
                return currentCount;
            },
            resetValue: function(){
                return currentCount=0;
            }
        };
    };

    $('.btn_now').on('click', function() {
        //alert('click_now');
        counter.resetValue();
        show_day=Boolean(true);
        show_week=Boolean(false);
        show_month=Boolean(false);
        hideAll();
        showData();
        $('#myNow').show();
        $('#myNowTwo').show();
        $('#myNowThree').show();
        $('.now').show();
        $('#time').show();
    });


    $('.btn_week').on('click', function() {
        //alert('click_week');
        counter.resetValue();
        show_day=Boolean(false);
        show_week=Boolean(true);
        show_month=Boolean(false);
        hideAll();
        showData();
        $('#myWeek').show();
        $('#myWeekTwo').show();
        $('#myWeekThree').show();
        $('.week').show();
        $('#time').show();

    });


    $('.btn_month').on('click', function() {
        //alert('click_month');
        counter.resetValue();
        show_day=Boolean(false);
        show_week=Boolean(false);
        show_month=Boolean(true);
        hideAll();
        showData();

        //console.log('month_loading');
        //console.log('ajax');
        //console.log('counter '+counter.getValue());
        //console.log('month_events_x '+ month_events_x);
        //console.log('month_events_y '+month_events_y);
        //console.log('month_events_x '+ month_events_two_x);
        //console.log('month_events_y '+month_events_two_y);
        //console.log('month_events_x '+ month_events_three_x);
        //console.log('month_events_y '+month_events_three_y);
        //console.log('create_chart_month');

        $('#myMonth').show();
        $('#myMonthTwo').show();
        $('#myMonthThree').show();
        $('.month').show();
        $('#time').show();

    });

    $('.btn_plus').click(function(){
        counter.getNext();
        console.log('ajax plus');
        showData();
        $('#time').show();
    });

    $('.btn_minus').click(function(){
        counter.getBack();
        console.log('ajax mius');
        showData();
        $('#time').show();
    });

    function showData(){

        setVariableInitial(JSON.parse(get_data_chart()));
        reloadChart();
        createTable();
    };

    function reloadChart(){
        //alert('reload chart');
        if(show_day) {
            console.log('now_events_x after plus'+ now_events_x);
            console.log('now_events_y  after plus'+now_events_y);
            console.log('time_now '+time_now);
            var myNow = ("<canvas id='myNow'></canvas>");
            var myNowTwo = ("<canvas id='myNowTwo'></canvas>");
            var myNowThree = ("<canvas id='myNowThree'></canvas>");
            var myNowFour = ("<canvas id='myNowFour'></canvas>");
            var label_table =  'Кол-во посещений пользователями на '+time_now;
            $('#myNow').remove();
            $('#myNowTwo').remove();
            $('#myNowThree').remove();
            $('#time').remove();
            $('.n').append("<div id='time'></div>");
            $('#time').append(label_table);
            $('.now').append(myNow, myNowTwo, myNowThree);
            line_chart('myNow','line',now_events_x, 'Активность', now_events_y, 'Кол-во переходов по ссылкам на '+time_now);
            line_chart('myNowTwo','horizontalBar',now_events_two_x, 'Востребованные ссылки', now_events_two_y, 'Востребованные ссылки на '+time_now);
            line_chart('myNowThree','horizontalBar',now_events_three_x, 'Количество пользователей ', now_events_three_y, 'Кол-во пользователей от организации на '+time_now);

        };
        if(show_week) {
            var label_table =  'Кол-во посещений пользователями на '+time_week;
            console.log('week_events_x after plus'+ week_events_x);
            console.log('week_events_y  after plus'+week_events_y);
            var myWeek = ("<canvas id='myWeek'></canvas>");
            var myWeekTwo = ("<canvas id='myWeekTwo'></canvas>");
            var myWeekThree = ("<canvas id='myWeekThree'></canvas>");
            $('#myWeek').remove();
            $('#myWeekTwo').remove();
            $('#myWeekThree').remove();
            $('.week').append(myWeek, myWeekTwo, myWeekThree);
            $('#time').remove();
            $('.n').append("<div id='time'></div>");
            $('#time').append(label_table);

            line_chart('myWeek','line', week_events_x, 'Активность', week_events_y, 'Кол-во переходов по ссылкам на '+time_week);
            line_chart('myWeekTwo','horizontalBar',week_events_two_x, 'Востребованные ссылки', week_events_two_y, 'Востребованные ссылки на '+time_week);
            line_chart('myWeekThree','horizontalBar', week_events_three_x, 'Количество пользователей ', week_events_three_y, 'Кол-во пользователей от организации на '+time_week);
            
        };
        if(show_month) {
            var label_table =  'Кол-во посещений пользователями на '+time_month;
            console.log('month_events_x after plus'+ month_events_x);
            console.log('month_events_y  after plus'+month_events_y);
            var myMonth = ("<canvas id='myMonth'></canvas>");
            var myMonthTwo = ("<canvas id='myMonthTwo'></canvas>");
            var myMonthThree = ("<canvas id='myMonthThree'></canvas>");
            $('#myMonth').remove();
            $('#myMonthTwo').remove();
            $('#myMonthThree').remove();
            $('.month').append(myMonth, myMonthTwo, myMonthThree);
            $('#time').remove();
            $('.n').append("<div id='time'></div>");
            $('#time').append(label_table);

            line_chart('myMonth','line', month_events_x, 'Активность', month_events_y, 'Кол-во переходов по ссылкам на '+ time_month);
            line_chart('myMonthTwo','horizontalBar',month_events_two_x, 'Востребованные ссылки', month_events_two_y, 'Востребованные ссылки на '+time_month);
            line_chart('myMonthThree','horizontalBar', month_events_three_x, 'Количество пользователей ', month_events_three_y, 'Кол-во пользователей от организации на ' + time_month);
        };
        console.log('boolean show_day, show_week, show_month'+ show_day+ ', '+ show_week+ ', '+ show_month);
    };


    function line_chart(id,charts,x,label,y, text) {
        var ctx = document.getElementById(id).getContext('2d');
        var chart = new Chart(ctx, {
            // The type of chart we want to create
            type: charts,
            // The data for our dataset
            data: {
                labels: x,
                datasets: [{

                    fill: false,  //заполняемость под графиком
                    label: label,
                    data: y,
                    borderColor: 'rgb(30,144,255)',
                    //borderColor: 'rgb(255,0,0)',
                    borderWidth: 2,
                    fontSize: 24
                }]
            },
            // Configuration options go here
            options: {
                //events: ["mousemove"],


                elements: {

                    line: {
                        tension: 0 // disables bezier curves
                    }
                },
                title: {
                    display: true,
                    position: 'top',
                    text: text,
                    fontSize: 20

                }
            }

        });
        //chart.update();


    }



//        console.log(counter.getValue());
//        count = counter.getValue();
//        console.log('countminus'+count);
//        $.ajax({
//            url: '/admin/monitoring/get_data_chart',
//            method: 'POST',
//            dataType: 'script',
//            data: {
//                count: count
//            }
//        });
//        $('canvas').hide();
//        line_chart('myNow',now_events_x, 'Кол-во переходов по ссылкам пользователями', now_events_y, 'Сутки');
//    });
//
//
//    var count;
//    console.log('count'+count);
//

    //$('.btn_plus').click(function(){
    //    counter.getNext();
    //    console.log(counter.getValue());
    //    count = counter.getValue();
    //    console.log('countplus'+count);
    //    $.ajax({
    //        url: '/admin/monitoring/get_data_chart',
    //        method: 'POST',
    //        dataType: 'script',
    //        data: {
    //            count: count
    //        }
    //    });
    //    $('canvas').hide();
    //    line_chart('myNow',now_events_x, 'Кол-во переходов по ссылкам пользователями', now_events_y, 'Сутки');
    //$('.btn_create').on('click', function() {
    //    $.ajax({
    //        url: '/admin/monitoring/get_data_chart',
    //        method: 'POST',
    //        dataType: 'script',
    //        data: {
    //            count: count
    //        }
    //    });
    //    $('canvas').hide();
    //    line_chart('myNow',now_events_x, 'Кол-во переходов по ссылкам пользователями', now_events_y, 'Сутки');
    //});
    //
    //$('.btn_boss').on('click', function() {
    //    $('canvas').hide();
    //    $('.well').hide();
    //});
    //
    //$('.btn_nav').on('click', function() {
    //    $('canvas').hide();
    //    $('.well').hide();
    //});
    //
    //console.log('now_x'+now_events_x);
    //console.log('now_y'+now_events_y);
    //$('.btn_now').on('click', function() {
    //    line_chart('myNow',now_events_x, 'Кол-во переходов по ссылкам пользователями', now_events_y, 'Сутки');
    //    $('#myNow').show();
    //    $('.now').show();
    //});
    //
    //console.log('week_x'+week_events_x);
    //console.log('week_y'+week_events_y);
    //$('.btn_week').on('click', function() {
    //    line_chart('myWeek', week_events_x, 'Кол-во переходов по ссылкам пользователями', week_events_y, 'Неделя');
    //    $('#myWeek').show();
    //    $('.week').show();
    //});
    //
    //console.log('month_x'+month_events_x);
    //console.log('month_y'+month_events_y);
    //$('.btn_month').on('click', function() {
    //    line_chart('myMonth', month_events_x, 'Кол-во переходов по ссылкам пользователями', month_events_y, 'Месяц');
    //    $('#myMonth').show();
    //    $('.month').show();
    //});
    //console.log('now_x'+now_events_x);
    //console.log('now_y'+now_events_y);
    //$('.btn_now').on('click', function() {
    //    line_chart('myNow',now_events_x, 'Кол-во переходов по ссылкам пользователями', now_events_y, 'Сутки');
    //    $('#myNow').show();
    //    $('.now').show();
    //});
    //
    //console.log('week_x'+week_events_x);
    //console.log('week_y'+week_events_y);
    //$('.btn_week').on('click', function() {
    //    line_chart('myWeek', week_events_x, 'Кол-во переходов по ссылкам пользователями', week_events_y, 'Неделя');
    //    $('#myWeek').show();
    //    $('.week').show();
    //});
    //
    //console.log('month_x'+month_events_x);
    //console.log('month_y'+month_events_y);
    //$('.btn_month').on('click', function() {
    //    line_chart('myMonth', month_events_x, 'Кол-во переходов по ссылкам пользователями', month_events_y, 'Месяц');
    //    $('#myMonth').show();
    //    $('.month').show();
    //});

});
