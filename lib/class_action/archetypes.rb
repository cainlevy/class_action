require 'class_action/verbs'

module ClassAction
  class IndexAction < GETAction
    respond_to :html

    def perform
      respond_with scope
    end

    def view_assigns
      {self.class.resource_name.underscore.pluralize => scope}
    end
  end

  class ShowAction < GETAction
    respond_to :html

    def perform
      respond_with resource
    end

    def resource
      @resource ||= scope.find(params[:id])
    end

    def view_assigns
      {self.class.resource_symbol => resource}
    end
  end

  class NewAction < GETAction
    respond_to :html

    def perform
      respond_with resource
    end

    def resource
      @resource ||= resource_type.new
    end

    def view_assigns
      {self.class.resource_symbol => resource}
    end
  end
  class CreateAction < POSTAction
    respond_to :html

    def perform
      resource.attributes = params[self.class.resource_symbol]
      resource.save
      respond_with resource
    end

    def resource
      @resource ||= resource_type.new
    end

    def view_assigns
      {self.class.resource_symbol => resource}
    end
  end

  class EditAction < GETAction
    respond_to :html

    def perform
      respond_with resource
    end

    def resource
      @resource ||= scope.find(params[:id])
    end

    def view_assigns
      {self.class.resource_symbol => resource}
    end
  end
  class UpdateAction < PUTAction
    respond_to :html

    def perform
      resource.attributes = params[self.class.resource_symbol]
      resource.save
      respond_with resource
    end

    def resource
      @resource ||= scope.find(params[:id])
    end

    def view_assigns
      {self.class.resource_symbol => resource}
    end
  end

  class DeleteAction < GETAction
    respond_to :html

    def perform
      respond_with resource
    end

    def resource
      @resource ||= scope.find(params[:id])
    end

    def view_assigns
      {self.class.resource_symbol => resource}
    end
  end
  class DestroyAction < DELETEAction
    respond_to :html

    def perform
      resource.destroy
      respond_with resource
    end

    def resource
      @resource ||= scope.find(params[:id])
    end

    def view_assigns
      {self.class.resource_symbol => resource}
    end
  end
end
