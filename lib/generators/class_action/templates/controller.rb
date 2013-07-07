module <%= controller_class_name %>Controller
  include ClassAction<% if options[:all] || options[:index] %>

  class Index < GETAction
    respond_to :html

    def perform
      respond_with <%= plural_resource_name %>
    end

    def <%= plural_resource_name %>
      @<%= plural_resource_name %> ||= scope
    end
  end<% end %><% if options[:all] || options[:show] %>

  class Show < GETAction
    respond_to :html

    def perform
      respond_with <%= singular_resource_name %>
    end

    def <%= singular_resource_name %>
      @<%= singular_resource_name %> ||= scope.find(params[:id])
    end
  end<% end %><% if options[:all] || options[:new] %>

  class New < GETAction
    respond_to :html

    def perform
      respond_with <%= singular_resource_name %>
    end

    def <%= singular_resource_name %>
      @<%= singular_resource_name %> ||= resource_type.new
    end
  end<% end %><% if options[:all] || options[:create] %>

  class Create < POSTAction
    respond_to :html

    def perform
      <%= singular_resource_name %>.attributes = params[:<%= singular_resource_name %>]
      <%= singular_resource_name %>.save

      respond_with <%= singular_resource_name %>
    end

    def <%= singular_resource_name %>
      @<%= singular_resource_name %> ||= resource_type.new
    end
  end<% end %><% if options[:all] || options[:edit] %>

  class Edit < GETAction
    respond_to :html

    def perform
      respond_with <%= singular_resource_name %>
    end

    def <%= singular_resource_name %>
      @<%= singular_resource_name %> ||= scope.find(params[:id])
    end
  end<% end %><% if options[:all] || options[:update] %>

  class Update < PUTAction
    respond_to :html

    def perform
      <%= singular_resource_name %>.attributes = params[:<%= singular_resource_name %>]
      <%= singular_resource_name %>.save

      respond_with <%= singular_resource_name %>
    end

    def <%= singular_resource_name %>
      @<%= singular_resource_name %> ||= scope.find(params[:id])
    end
  end<% end %><% if options[:all] || options[:delete] %>

  class Delete < GETAction
    respond_to :html

    def perform
      respond_with <%= singular_resource_name %>
    end

    def <%= singular_resource_name %>
      @<%= singular_resource_name %> ||= scope.find(params[:id])
    end
  end<% end %><% if options[:all] || options[:destroy] %>

  class Destroy < DELETEAction
    respond_to :html

    def perform
      <%= singular_resource_name %>.destroy

      respond_with <%= singular_resource_name %>
    end

    def <%= singular_resource_name %>
      @<%= singular_resource_name %> ||= scope.find(params[:id])
    end
  end<% end %>
end
