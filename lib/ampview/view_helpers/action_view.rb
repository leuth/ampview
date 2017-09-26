module Ampview
  module ViewHelpers
    module ActionView

      def ampview_amphtml_link_tag
        return '' unless Ampview.target?(controller.controller_path, controller.action_name)

        amp_uri = URI.parse(request.url)
        if request.path == root_path
          amp_path = "#{controller.controller_path}/#{controller.action_name}.#{Ampview.default_format}"
        else
          amp_path = ".#{Ampview.default_format}"
        end
        amp_uri.path = amp_uri.path # + amp_path
        amp_uri.query = ERB::Util.h(amp_uri.query) if amp_uri.query.present?

        %Q(<link rel="amphtml" href="#{amp_uri.to_s}" />).html_safe
      end

      def ampview_html_header
        header =<<"EOS"
<!-- Snipet for amp library. -->
    <style amp-boilerplate>body{-webkit-animation:-amp-start 8s steps(1,end) 0s 1 normal both;-moz-animation:-amp-start 8s steps(1,end) 0s 1 normal both;-ms-animation:-amp-start 8s steps(1,end) 0s 1 normal both;animation:-amp-start 8s steps(1,end) 0s 1 normal both}@-webkit-keyframes -amp-start{from{visibility:hidden}to{visibility:visible}}@-moz-keyframes -amp-start{from{visibility:hidden}to{visibility:visible}}@-ms-keyframes -amp-start{from{visibility:hidden}to{visibility:visible}}@-o-keyframes -amp-start{from{visibility:hidden}to{visibility:visible}}@keyframes -amp-start{from{visibility:hidden}to{visibility:visible}}</style><noscript><style amp-boilerplate>body{-webkit-animation:none;-moz-animation:none;-ms-animation:none;animation:none}</style></noscript>
    <script async src="https://cdn.ampproject.org/v0.js"></script>
EOS
        header.html_safe
      end

      def ampview_google_analytics_head
        return '' if Ampview.analytics.blank?

        analytics_head =<<"EOS"
<!-- Google Analytics for amp pages. -->
    <script async custom-element="amp-analytics" src="https://cdn.ampproject.org/v0/amp-analytics-0.1.js"></script>
EOS
        analytics_head.html_safe
      end

      def ampview_google_analytics_page_tracking
        return '' if Ampview.analytics.blank?

        analytics_code =<<"EOS"
<!-- Google Analytics Page Tracking for amp pages. -->
    <amp-analytics type="googleanalytics" id="ampview_analytics">
      <script type="application/json">
      {
        "vars": {
          "account": "#{Ampview.analytics}"
        },
        "triggers": {
          "trackPageview": {
            "on": "visible",
            "request": "pageview"
          }
        }
      }
      </script>
    </amp-analytics>
EOS
        analytics_code.html_safe
      end

      def ampview_canonical_url
        request.url.gsub(".#{Ampview.default_format.to_s}", '')
      end

      def amp_renderable?
        Ampview.amp_renderable?(controller.controller_path, controller.action_name)
      end

      ::ActionView::Base.send :include, self
    end
  end
end
