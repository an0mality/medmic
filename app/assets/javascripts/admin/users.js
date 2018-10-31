$(document).ready(function() {
    jQuery(".best_in_place").best_in_place();

    $('#email').autocomplete({
        minLength: 1,
        source: "/admin/users/search_email"

    });

    $('#username').autocomplete({
        minLength: 1,
        source: "/admin/users/search_login"

    });

    $('#organization_name').autocomplete({
        minLength: 1,
        source: "/admin/users/search_org"

    });

    $('#fio').autocomplete({
        minLength: 1,
        source: "/admin/users/search_fio"

    });

});

