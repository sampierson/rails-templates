require 'nokogiri'
require 'fileutils'

module JsFixtureBuilder

  # Saves the markup to a fixture file using the given name
  def save_fixture(markup, name)
    fixture_path = Rails.root.join('spec/javascripts/fixtures')
    FileUtils.mkdir_p(fixture_path) unless File.exists?(fixture_path)

    fixture_file = File.join(fixture_path, "#{name}.html")
    File.open(fixture_file, 'w') do |file|
      file.puts(markup)
    end
  end

  # From the controller spec response body, extracts html identified
  # by the css selector.
  def html_for(selector)
    doc = Nokogiri::HTML(response.body)
    doc.css('#load-javascripts').each do |node|
      node.children.remove
      node.content = 'Javascripts removed.'
    end
    content = doc.css(selector).first.to_s
    convert_body_tag_to_div(content)
  end

  # Many of our css and jQuery selectors rely on a class attribute we
  # normally embed in the <body>. For example:
  #
  # <body class="workspaces show">
  #
  # Here we convert the body tag to a div so that we can load it into
  # the document running js specs without embedding a <body> within a <body>.
  def convert_body_tag_to_div(markup)
    markup.gsub("<body", '<div').gsub("</body>", "</div>")
  end
end
