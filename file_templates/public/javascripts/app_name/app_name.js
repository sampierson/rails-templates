<%= app_const_base %> = {

  /*
   * This is the page-specific JavaScript framework.  It allows you to target JS to only run for one page (specific
   * controller/action) or for all actions for a specific controller.
   *
   * How it works:
   *
   * We uniquely identify pages by putting the Rails controller/action names in data-controller_name and
   * data-action_name on the HTML body tag.
   *
   * At page load time, these names are converted into 2 JavaScript classes,
   * e.g. for controller#action FooController#bar, the class names <%= app_const_base %>.FooPages and <%= app_const_base %>.FooBarPage are generated.
   *
   * If either of these classes actually exist, it's init() method is called.
   *
   * We store the page specific JS class definitions in javascripts/<%= app_const_base.downcase %>/pages.
   * All files there are automatically included in the page.
   */
  Pages: {
    init : function() {
      <%= app_const_base %>.Pages.pageSpecificInit();
    },

    pageSpecificInit: function() {
      var controllerName = $('body').attr('data-controller_name');
      var actionName = $('body').attr('data-action_name');
      if (controllerName == undefined) {
        return;
      }

      var controllerClassName = <%= app_const_base %>.camelCase(controllerName) + 'Pages';
      if(<%= app_const_base %>[controllerClassName]) {
        <%= app_const_base %>[controllerClassName].init();
      }

      var pageClassName =  <%= app_const_base %>.camelCase(controllerName) + <%= app_const_base %>.camelCase(actionName) + 'Page';
      if(<%= app_const_base %>[pageClassName]) {
        <%= app_const_base %>[pageClassName].init();
      }
    }
  },

  camelCase: function(str) {
    var newStr = str.replace(/_(.)/g, function(match, firstChar) {
      return firstChar.toUpperCase();
    });
    return newStr.replace(/^(.)/, function(match, firstChar) {
      return firstChar.toUpperCase();
    });
  }
};

$(document).ready(<%= app_const_base %>.Pages.init);
