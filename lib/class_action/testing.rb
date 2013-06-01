require 'action_controller/test_case'

if Rails::VERSION::MAJOR == 3 && Rails::VERSION::MINOR == 2
  # fix #process to use #controller_path for :controller_class_name
  module ActionController
    class TestCase
      module Behavior

        def process(action, parameters = nil, session = nil, flash = nil, http_method = 'GET')
          # Ensure that numbers and symbols passed as params are converted to
          # proper params, as is the case when engaging rack.
          parameters = paramify_values(parameters) if html_format?(parameters)

          # Sanity check for required instance variables so we can give an
          # understandable error message.
          %w(@routes @controller @request @response).each do |iv_name|
            if !(instance_variable_names.include?(iv_name) || instance_variable_names.include?(iv_name.to_sym)) || instance_variable_get(iv_name).nil?
              raise "#{iv_name} is nil: make sure you set it in your test's setup method."
            end
          end

          @request.recycle!
          @response.recycle!
          @controller.response_body = nil
          @controller.formats = nil
          @controller.params = nil

          @html_document = nil
          @request.env['REQUEST_METHOD'] = http_method

          parameters ||= {}
          controller_class_name = @controller.class.anonymous? ?
            "anonymous_controller" :
            @controller.class.controller_path

          @request.assign_parameters(@routes, controller_class_name, action.to_s, parameters)

          @request.session = ActionController::TestSession.new(session) if session
          @request.session["flash"] = @request.flash.update(flash || {})
          @request.session["flash"].sweep

          @controller.request = @request
          build_request_uri(action, parameters)
          @controller.class.class_eval { include Testing }
          @controller.recycle!
          @controller.process_with_new_base_test(@request, @response)
          @assigns = @controller.respond_to?(:view_assigns) ? @controller.view_assigns : {}
          @request.session.delete('flash') if @request.session['flash'].blank?
          @response
        end

      end
    end
  end
end
