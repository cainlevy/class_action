require 'action_controller/test_case'

# fix #process to use #controller_path for :controller_class_name
# patch is in Rails-4.1.0.beta
if Rails::VERSION::MAJOR == 4 && Rails::VERSION::MINOR == 0
  module ActionController
    class TestCase
      module Behavior

        def process(action, http_method = 'GET', *args)
          check_required_ivars
          http_method, args = handle_old_process_api(http_method, args, caller)

          if args.first.is_a?(String) && http_method != 'HEAD'
            @request.env['RAW_POST_DATA'] = args.shift
          end

          parameters, session, flash = args

          # Ensure that numbers and symbols passed as params are converted to
          # proper params, as is the case when engaging rack.
          parameters = paramify_values(parameters) if html_format?(parameters)

          @html_document = nil

          unless @controller.respond_to?(:recycle!)
            @controller.extend(Testing::Functional)
            @controller.class.class_eval { include Testing }
          end

          @request.recycle!
          @response.recycle!
          @controller.recycle!

          @request.env['REQUEST_METHOD'] = http_method

          parameters ||= {}
          controller_class_name = @controller.class.anonymous? ?
            "anonymous" :
            @controller.class.name.underscore.sub(/_controller$/, '')

          @request.assign_parameters(@routes, controller_class_name, action.to_s, parameters)

          @request.session.update(session) if session
          @request.flash.update(flash || {})

          @controller.request  = @request
          @controller.response = @response

          build_request_uri(action, parameters)

          name = @request.parameters[:action]

          @controller.process(name)

          if cookies = @request.env['action_dispatch.cookies']
            cookies.write(@response)
          end
          @response.prepare!

          @assigns = @controller.respond_to?(:view_assigns) ? @controller.view_assigns : {}
          @request.session['flash'] = @request.flash.to_session_value
          @request.session.delete('flash') if @request.session['flash'].blank?
          @response
        end
      end
    end
  end

elsif Rails::VERSION::MAJOR == 3 && Rails::VERSION::MINOR == 2
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
