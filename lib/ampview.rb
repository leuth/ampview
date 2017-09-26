require "ampview/version"

if defined?(Rails::Railtie)
  require 'ampview/railtie'
else
  raise 'Ampview is not compatible with Rails 5.0 or older'
end

module Ampview
  autoload :Config, 'ampview/config'

  extend(Module.new {
    def config
      Thread.current[:ampview_config] ||= Ampview::Config.new
    end

    def config=(value)
      Thread.current[:ampview_config] = value
    end

    # Write methods which delegates to the configuration object.
    %w( format config_file load_config default_format targets analytics lookup_formats ).each do |method|
      module_eval <<-DELEGATORS, __FILE__, __LINE__ + 1
        def #{method}
          config.#{method}
        end

        def #{method}=(value)
          config.#{method} = (value)
        end
      DELEGATORS
    end

    def reload_config!
      config.load_config = config.send(:config_load_config)
      config.default_format = config.send(:config_default_format)
      config.targets = config.send(:config_targets)
      config.analytics = config.send(:config_analytics)
      config.lookup_formats = config.send(:config_lookup_formats)
      nil
    end

    def disable_all?
      targets.blank?
    end

    def enable_all?
      targets['application'] == 'all'
    end

    def controller_all?(key)
      targets.has_key?(key) && targets[key].blank?
    end

    def controller_actions?(key)
      targets.has_key?(key) && targets[key].present?
    end

    def target_actions(controller)
      extract_target_actions(controller) - %w(new create edit update destroy)
    end

    def extract_target_actions(controller)
      return []                             if disable_all?
      return controller.action_methods.to_a if enable_all?
      key = controller_to_key(controller)
      return controller.action_methods.to_a if controller_all?(key)
      return targets[key]                   if controller_actions?(key)
      []
    end

    def controller_to_key(controller)
      controller.name.underscore.sub(/_controller\z/, '')
    end

    def key_to_controller(key)
      (key.camelcase + 'Controller').constantize
    end

    def target?(controller_path, action_name)
      target_actions = target_actions( key_to_controller(controller_path) )
      action_name.in?(target_actions)
    end

    def amp_format?
      format == default_format.to_s
    end

    def amp_renderable?(controller_path, action_name)
      amp_format? && target?(controller_path, action_name)
    end
  })
end
