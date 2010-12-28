describe("Idn.AdminUsersIndexPage", function() {
  describe("init", function() {
    it("should ajaxify the table links", function() {
      spyOn(Idn.AdminUsersIndexPage, 'ajaxifyTableLinks');
      Idn.AdminUsersIndexPage.init();
      expect(Idn.AdminUsersIndexPage.ajaxifyTableLinks).toHaveBeenCalled();
    });

    it("should ajaxify the search form", function() {
      spyOn(Idn.AdminUsersIndexPage, 'ajaxifySearchForm');
      Idn.AdminUsersIndexPage.init();
      expect(Idn.AdminUsersIndexPage.ajaxifySearchForm).toHaveBeenCalled();
    });
  });

  describe("ajaxifyTableLinks", function() {
    it("should ajaxify the user table column sort headings", function() {
    });
  });

  describe("ajaxifySearchForm", function() {
    it("should ajaxify the user search form", function() {
    });
  });
});
