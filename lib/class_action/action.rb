module ClassAction
  module Action
    extend ActiveSupport::Concern

    # the minimum implementation
    #
    # archetypal actions provide default implementations that may be
    # customized by overwriting methods like #scope or by overwriting
    # the entire #perform method.
    def perform
      raise NotImplementedError
    end

    protected

    # the scope used to find resources
    #
    # used by many archetypes. this is the place to add scopes for
    # security (e.g. current_user.association) or for filtering
    # (e.g. current_user.association.published)
    def scope
      resource_type
    end

    # the resource object represented by the endpoint.
    #
    # commonly an ActiveRecord class, although the archetypes mostly
    # just assume that it responds to #attributes= and #find(id).
    def resource_type
      @resource ||= self.class.resource_name.constantize
    end

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

      # infer the resource name from our namespace convention
      # e.g. 'Foo' from Admin::FooController::Index
      def resource_name
        @resource_name ||= parent_module.demodulize.sub(/Controller?$/, '').singularize
      end

      # a common manipulation of resource_name, cached for performance
      def resource_symbol
        @resource_symbol ||= resource_name.underscore.to_sym
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
