require 'ampview/overrider'

module Ampview
  class Railtie < Rails::Railtie
    initializer 'ampview' do |app|
      ActiveSupport.on_load :action_controller do
        include Ampview::Overrider
      end

      ActiveSupport.on_load :action_view do
        require 'ampview/view_helpers/action_view'
      end

      require 'ampview/view_helpers/image_tag_helper'
      require 'ampview/view_helpers/form_tag_helper'
      require 'ampview/view_helpers/form_helper'
    end
  end
end
