# ClassAction

A controller pattern for Rails that uses dedicated classes for each action. This promotes cleaner code by applying the Single Responsibility Principle.

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

Or more succinctly, since `perform` is the only required method:

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

Provides a convenient place to factor request handling logic without fattening the models unnecessarily.

Promotes the use of concerns (mixins) to share behavior between actions.

The view can reference the controller as a light-weight view object. This provides a convenient way to extract some view logic.

Simplifies controller filters. The `:only` and `:except` options disappear when filters are only declared on the action classes that use it.

Discourages anti-patterns:

* Instead of actions that check the request's verb, create separate actions for each verb and share logic through a concern.
* Instead of checking the current controller and action names, include logic into only the actions that use it.

Potential future benefits:

* Could build a declarative DSL to strongly type parameters. This effort could be reused to also generate API documentation.
* Could pave the way to deprecate ivar assigns. Instead, the views could reference controller methods for the objects they expect.

## VERB inheritance

The base classes inherit from `ActionController::Base` for each HTTP verb. Your application might customize these with behavior specific to certain verbs, such as `protect_from_forgery`.

* [GETAction]
* [POSTAction]
* [PUTAction]
* [DELETEAction]

## Keeping DRY

Each action class will automatically include two modules:

* The controller module (e.g. `FoosController` itself), for concerns that apply to each action on the resource.
* A global ApplicationConcerns module for concerns that apply across the entire application.

## Installation

Add this line to your application's Gemfile:

    gem 'class_action'

And then execute:

    $ bundle

## Generators

ClassAction provides generators to assist with boilerplate and standard RESTful setups.

    # creates an empty Posts controller:
    rails generate class_action:controller post

    # creates a Posts controller with a few RESTful actions:
    rails generate class_action:controller post --index --show --create

    # creates a Posts controller with all RESTful actions:
    rails generate class_action:controller post --all

## Transitioning Existing Applications

ClassAction is lightweight and can live side-by-side with legacy controller classes. The investment cost lies in moving ApplicationController methods and logic into ApplicationConcerns, then including ApplicationConcerns for backwards compatibility.

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

## TODO

* Double-check dev environment reloading.
* Add DSL for parameter typing. Virtus? Hide parameters behind strong typing accessors. Make `params` give deprecation warnings.
* Build up from AbstractController::Base instead of ActionController::Base. Drop HideActions and clean up #visible_action?.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
