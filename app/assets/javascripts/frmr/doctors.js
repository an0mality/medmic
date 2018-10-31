$(document).ready(function() {

    $('#surname').autocomplete({
        minLength: 3,
        source: "/frmr/doctors/search_surname"

    });

    $('#code').autocomplete({
        minLength: 2,
        source: "/frmr/doctors/search_code"

    });
});
