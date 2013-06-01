module ClassAction
  extend ActiveSupport::Concern

  module ClassMethods
    # compatibility
    #
    # this translates the old Controller#action paradigm
    # into the new Controller::Action#perform paradigm
    #
    # see ActionController::Metal.action
    def action(name, klass = ActionDispatch::Request)
      const_get(name.camelize).action(:perform, klass)
    end
  end
end

require_relative 'application_concerns'
require_relative 'class_action/railtie'
require_relative 'class_action/action'
