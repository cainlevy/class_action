module ClassAction
  class Railtie < Rails::Railtie
    initializer "class_action.finish_loading", after: "action_controller.set_configs" do
      # these can't be loaded until after ActionController's set_configs initializer
      # because that initializer adds "inherited" behavior to ActionController::Base
      # and our verbs and won't function properly if they inherit prior.
      require_relative 'verbs'
    end
  end
end
