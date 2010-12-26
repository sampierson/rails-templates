unless Rails.env == 'production'

  namespace :l10n do

    desc "Create the fa-KE locale by morphing locale 'en'"
    task :create_fake do
      def convert(string)
        newstring = "X-"
        count = 0
        string.each_char do |c|
          newstring << ((count % 2 == 0) ? c.upcase : c.downcase)
          count += 1
        end
        newstring << "-X"
        if newstring =~ /%\{(.+)\}/
          newstring.gsub!(/%\{(.+)\}/, "%{#{$1.downcase}}")
        end
        newstring
      end

      def recursively_convert(nested_hash)
        newhash = {}
        nested_hash.each do |key, value|
          newhash[key] = value.is_a?(String) ? convert(value) : recursively_convert(value)
        end
        newhash
      end

      Dir.glob(Rails.root.join('config', 'locales', '*en.yml')).each do |filename|
        en_data = YAML.load_file(filename)
        fa_ke_data = { 'fa-KE' => recursively_convert(en_data['en']) }
        File.open(filename.gsub('.en.yml', '.fa-KE.yml'), 'w') do |file|
          file.write fa_ke_data.to_yaml
        end
      end
    end
  end
end
