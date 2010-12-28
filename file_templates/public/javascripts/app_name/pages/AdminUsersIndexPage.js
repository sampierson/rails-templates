Idn.AdminUsersIndexPage = {
  init: function() {
    Idn.AdminUsersIndexPage.ajaxifyTableLinks();
    Idn.AdminUsersIndexPage.ajaxifySearchForm();
  },

  ajaxifyTableLinks: function() {
    // Sorting and pagination links.
    $('#users th a, #users .pagination a').live('click', function () {
      $.getScript(this.href);
      return false;
    });
  },

  ajaxifySearchForm: function() {
    // Search form.
    $('#users_search').submit(function () {
      $.get(this.action, $(this).serialize(), null, 'script');
      return false;
    });
  }
};
