module Ampview
  module ViewHelpers
    module FormTagHelper

      def form_tag_html(html_options)
        extra_tags = extra_tags_for_form(html_options)
        # html_options['action-xhr'] = html_options.delete('action')
        tag(:form, html_options, true) + extra_tags
      end

      def form_tag_with_body(html_options, content)
        output = form_tag_html(html_options)
        output << content
        output.safe_concat('</form>')
      end

      def extra_tags_for_form(html_options)
        authenticity_token = html_options.delete('authenticity_token')
        method = html_options.delete('method').to_s.downcase

        method_tag = \
          case method
          when 'get'
            html_options['method'] = 'get'
            ''
          when 'post', ''
            html_options['method'] = 'post'
            token_tag(authenticity_token, form_options: {
              action: html_options['action-xhr'],
              method: 'post'
            })
          else
            html_options['method'] = 'post'
            method_tag(method) + token_tag(authenticity_token, form_options: {
              action: html_options['action-xhr'],
              method: method
            })
          end

        if html_options.delete('enforce_utf8') { true }
          utf8_enforcer_tag + method_tag
        else
          method_tag
        end
      end

      ::ActionView::Base.send :prepend, self
    end
  end
end
