module Ampview
  module Overrider
    extend ActiveSupport::Concern

    included do
      before_action do
        Ampview.format = request[:format]
        if Ampview.amp_renderable?(controller_path, action_name)  # default_format is :amp
          override_actions_with_ampview
        end
      end
    end

    private

      def override_actions_with_ampview
        klass = self.class  # klass is controller class
        return if klass.ancestors.include?(Ampview::ActionOverrider)
        actions = Ampview.target_actions(klass)

        klass.class_eval do
          Ampview::ActionOverrider.module_eval do
            actions.to_a.each do |action|
              define_method action.to_sym do
                super()
                unless performed?
                  respond_to do |format|
                    format.send(Ampview.default_format.to_sym) do
                      lookup_context.formats = [Ampview.default_format] + Ampview.lookup_formats
                      render layout: 'ampview_application.amp'
                    end
                  end
                end
              end
            end
          end
          prepend Ampview::ActionOverrider
        end
      end
  end

  module ActionOverrider
  end
end
