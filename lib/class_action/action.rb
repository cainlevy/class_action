module ClassAction
  module Action
    extend ActiveSupport::Concern

    # the minimum implementation
    def perform
      raise NotImplementedError
    end

    protected

    # AbstractController compat
    def action_name
      self.class.action_name
    end

    # compat for common test phrasing, e.g. `get :index`
    # TODO: deprecate by improving test pattern now that both "get" and "index" are superfluous
    def action_missing(name, *args)
      if name == action_name
        perform
      else
        raise AbstractController::ActionNotFound
      end
    end

    module ClassMethods
      def inherited(subclass)
        super
        unless subclass.name =~ /^ClassAction::/ # UGLY
          subclass.class_eval do
            include parent_module.constantize if parent_module.present?
            include ApplicationConcerns
          end
        end
      end

      def action_name
        @action_name ||= name.demodulize.underscore
      end

      # compat for ActionController::HideActions (which isn't even needed in this approach)
      def visible_action?(name)
        true #['perform', action_name].include? name
      end

      # the containing controller (resource) module
      #
      # e.g. 'Admin::FooController' from Admin::FooController::Index
      def parent_module
        @parent_module ||= name.deconstantize
      end

      # AbstractController compat
      def controller_path
        @controller_path ||= parent_module.sub(/Controller?$/, '').underscore
      end
    end
  end
end
