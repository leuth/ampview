module Ampview
  module ViewHelpers
    module FormHelper
      AMP_FORM_PERMITTED_ATTRIBUTES = %w[
        target action action-xhr accept accept-charset autocomplete
        enctype method name novalidate target
      ].freeze

      def amp_form_tag(record, options = {}, &block)
        raise ArgumentError, 'Missing block' unless block_given?
        html_options = options[:html] ||= {}

        case record
        when String, Symbol
          object_name = record
          object      = nil
        else
          object      = record.is_a?(Array) ? record.last : record
          raise ArgumentError, 'First argument in form cannot contain nil or be empty' unless object
          object_name = options[:as] || model_name_from_record_or_class(object).param_key
          apply_form_for_options!(record, object, options)
        end

        html_options[:data]   = options.delete(:data)   if options.has_key?(:data)
        html_options[:remote] = options.delete(:remote) if options.has_key?(:remote)
        html_options[:method] = options.delete(:method) if options.has_key?(:method)
        html_options[:enforce_utf8] = options.delete(:enforce_utf8) if options.has_key?(:enforce_utf8)
        html_options[:authenticity_token] = options.delete(:authenticity_token)

        builder = instantiate_builder(object_name, object, options)
        output  = capture(builder, &block)
        html_options[:multipart] ||= builder.multipart?

        html_options = html_options_for_form(options[:url] || {}, html_options)
        options.select! { |key, _| key.to_s.in?(AMP_FORM_PERMITTED_ATTRIBUTES) }
        form_tag_with_body(html_options, output)
      end

      def form_for(record, options = {}, &block)
        if controller && Ampview.amp_renderable?(controller.controller_path, controller.action_name)
          amp_form_tag(record, options, &block)
        else
          super
        end
      end

      private

      ::ActionView::Base.send :prepend, self
    end
  end
end
