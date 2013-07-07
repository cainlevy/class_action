# ClassAction

A controller pattern for Rails that supports separate classes for each action. This promotes cleaner code by applying the Single Responsibility Principle.

## Example

A well-factored action:

    # app/controllers/foos_controller.rb
    module FoosController
      include ClassAction

      class Index < GETAction
        respond_to :html

        def perform
          respond_with foo
        end

        def foo
          @foo ||= scope.find(params[:id])
        end

        protected

        def scope
          Foo
        end
      end
    end

Or more succinctly:

    # app/controllers/foos_controller.rb
    module FoosController
      include ClassAction

      class Index < IndexAction
        respond_to :html

        def perform
          @foo = Foo.find(params[:id])
          respond_with @foo
        end
      end
    end

## Benefits

Promotes the use of mixins (concerns) to share behavior between actions.

Simplifies controller filters. The `:only` and `:except` options disappear when filters are only declared on the action classes that use it.

Actions that behave differently based on the request's verb are considered an anti-pattern. Instead, create a separate action for each verb.

Behavior that checks the current controller and action names is also considered an anti-pattern. Instead, include the logic into only the controller actions that use it.

The view can reference the controller as a light-weight view object. This provides a convenient way to extract view logic and access data without ivar assigns.

unimplemented: Parameters can be strongly typed with a declarative DSL to validate requests. This effort could be reused to also generate API documentation.

## VERB inheritance

The base classes inherit from `ActionController::Base` for each HTTP verb. Your application might customize these with behavior specific to certain verbs, such as `protect_from_forgery`.

* [GETAction]
* [POSTAction]
* [PUTAction]
* [DELETEAction]

## Keeping DRY

Each action class will include two modules:
* The controller module (e.g. `FoosController` itself), for concerns that apply to each action on the resource.
* A global ApplicationConcerns module for concerns that apply across the entire application.

## Transitioning Existing Applications

ClassAction can live side-by-side with legacy controllers classes. The initial cost lies in moving ApplicationController methods and logic into ApplicationConcerns, then including ApplicationConcerns for backwards compatibility.

Before:

    # app/controllers/application_controller.rb
    class ApplicationController < ActionController::Base
      def some_shared_method
        # ...
      end
    end

After:

    # app/controllers/concerns/application_concerns.rb
    module ApplicationConcerns
      def some_shared_method
        # ...
      end
    end

    # app/controllers/application_controller.rb
    class ApplicationController < ActionController::Base
      include ApplicationConcerns
    end

## Generators

ClassAction provides generators to assist with boilerplate and simple RESTful setups.

    # creates an empty Posts controller:
    rails generate class_action:controller post

    # creates a Posts controller with a few RESTful actions:
    rails generate class_action:controller post --index --show --create

    # creates a Posts controller with all RESTful actions:
    rails generate class_action:controller post --all

## Installation

Add this line to your application's Gemfile:

    gem 'class_action'

And then execute:

    $ bundle

## TODO

* Figure out dev environment reloading.
* Add DSL for parameter typing. Virtus? Hide parameters behind strong typing accessors. Make `params` give deprecation warnings.
* Build up from AbstractController::Base instead of ActionController::Base. Drop HideActions and clean up #visible_action?.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
