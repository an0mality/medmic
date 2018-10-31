$(document).ready(function() {
    var search_btn = document.getElementsByClassName('btn');
    for(var i =0; i< search_btn.length; i++){
        search_btn[i].onclick = showSpinner;
    };

    function showSpinner(){
        $('.spinner').show()
        setTimeout(function() { $('.spinner').hide(); }, 2000);
    };
});

// show spinner on AJAX start
$(document).ajaxStart(function(){
    $(".spinner").show();
});

// hide spinner on AJAX stop
$(document).ajaxStop(function(){
    $(".spinner").hide();
});