<%= app_const_base %>.AdminUsersIndexPage = {
  init: function() {
    <%= app_const_base %>.AdminUsersIndexPage.addBehaviorToUsersTableHeadings();
    <%= app_const_base %>.AdminUsersIndexPage.addBehaviorToSearchForm();
  },

  addBehaviorToUsersTableHeadings: function() {
    // Sorting and pagination links.
    $('#users th a, #users .pagination a').live('click', function () {
      $.getScript(this.href);
      return false;
    });
  },

  addBehaviorToSearchForm: function() {
    // Search form.
    $('#users_search').submit(function () {
      $.get(this.action, $(this).serialize(), null, 'script');
      return false;
    });
  }
};
