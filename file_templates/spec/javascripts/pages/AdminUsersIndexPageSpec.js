describe("<%= app_const_base %>.AdminUsersIndexPage", function() {
  beforeEach(function() {
    loadFixtures('admin_users_controller_index.html');
  });

  describe("init", function() {
    it("should add behavior to the user table headings", function() {
      spyOn(<%= app_const_base %>.AdminUsersIndexPage, 'addBehaviorToUsersTableHeadings');
      <%= app_const_base %>.AdminUsersIndexPage.init();
      expect(<%= app_const_base %>.AdminUsersIndexPage.addBehaviorToUsersTableHeadings).toHaveBeenCalled();
    });

    it("should add behavior to the search form", function() {
      spyOn(<%= app_const_base %>.AdminUsersIndexPage, 'addBehaviorToSearchForm');
      <%= app_const_base %>.AdminUsersIndexPage.init();
      expect(<%= app_const_base %>.AdminUsersIndexPage.addBehaviorToSearchForm).toHaveBeenCalledWith();
    });
  });

  describe("addBehaviorToUsersTableHeadings", function() {
    it("should setup column headings to invoke getScript with a sort column & direction", function() {
      spyOn(jQuery, 'getScript');
      <%= app_const_base %>.AdminUsersIndexPage.addBehaviorToUsersTableHeadings();
      var $roleLink = $('#users th.role a');
      $roleLink.click();
      expect($.getScript).toHaveBeenCalledWith('http://localhost:8888/admin/users?direction=asc&sort=role');
    });
  });

  describe("addBehaviorToSearchForm", function() {
    it("should setup the search form to perform a get with the search input value", function() {
      spyOn(jQuery, 'get');
      <%= app_const_base %>.AdminUsersIndexPage.addBehaviorToSearchForm();
      var $form = $('form#users_search');
      $('input#search').val('fake-search');
      $form.submit();
      expect($.get).toHaveBeenCalled();
      expect($.get.mostRecentCall.args[0]).toEqual('http://localhost:8888/admin/users');
      expect($.get.mostRecentCall.args[1]).toMatch('search=fake-search');
    });
  });
});
