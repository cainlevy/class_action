require 'rails/generators/resource_helpers'

module ClassAction
  module Generators
    class ControllerGenerator < Rails::Generators::NamedBase
      class_option :all,      type: :boolean, default: false,
        desc: 'Generates scaffolding for all actions'
      class_option :index,    type: :boolean, default: false,
        desc: 'Generates scaffolding for #index'
      class_option :show,     type: :boolean, default: false,
        desc: 'Generates scaffolding for #show'
      class_option :new,      type: :boolean, default: false,
        desc: 'Generates scaffolding for #new'
      class_option :create,   type: :boolean, default: false,
        desc: 'Generates scaffolding for #create'
      class_option :edit,     type: :boolean, default: false,
        desc: 'Generates scaffolding for #edit'
      class_option :update,   type: :boolean, default: false,
        desc: 'Generates scaffolding for #update'
      class_option :delete,   type: :boolean, default: false,
        desc: 'Generates scaffolding for #delete'
      class_option :destroy,  type: :boolean, default: false,
        desc: 'Generates scaffolding for #destroy'

      source_root File.join(File.dirname(__FILE__), 'templates')
      include Rails::Generators::ResourceHelpers

      check_class_collision :suffix => "Controller"

      def create_controller_files
        template 'controller.rb', File.join('app/controllers', class_path, "#{controller_file_name}_controller.rb")
      end

      hook_for :template_engine, as: :scaffold
      hook_for :test_framework

      alias_method :plural_resource_name, :plural_table_name
      alias_method :singular_resource_name, :singular_table_name
    end
  end
end
