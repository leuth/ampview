require 'rails/generators'

module Ampview
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    def inject_amp_mime_type_into_file
      inject_into_file 'config/initializers/mime_types.rb',
                            after: %Q(# Mime::Type.register "text/richtext", :rtf\n) do <<-'RUBY'
Mime::Type.register_alias 'text/html', Ampview.default_format
RUBY
      end
    end

    def create_config_file
      copy_file 'ampview.yml', 'config/ampview.yml'
    end

    def create_application_layout
      copy_file 'ampview_application.amp.slim', 'app/views/layouts/ampview_application.amp.slim'
    end
  end
end
