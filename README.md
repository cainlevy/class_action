# ClassAction

A controller pattern for Rails that supports separate classes for each action. This promotes cleaner code by applying the Single Responsibility Principle.

## Example

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

## Keeping DRY

Each action class will include two modules:
* The controller module (e.g. `FoosController` itself), for concerns that apply to each action on the resource.
* A global ApplicationConcerns module for concerns that apply across the entire application. (This could've been named ApplicationController, but it would complicate transitioning mature codebases.)

## VERB inheritance

The base classes inherit from `ActionController::Base` for each HTTP verb. Your application might customize these with behavior specific to certain verbs, such as `protect_from_forgery`.

* [GETAction]
* [POSTAction]
* [PUTAction]
* [DELETEAction]

## Generators

ClassAction provides generators to assist with boilerplate and simple RESTful setups.

    # creates an empty Posts controller:
    rails generate class_action:controller post

    # creates a Posts controller with a few RESTful actions:
    rails generate class_action:controller post --index --show --create

    # creates a Posts controller with all RESTful actions:
    rails generate class_action:controller post --all

## TODO

* Tests generator (with scaffolding options) (test unit)
* Views generator (with scaffolding options) (erb)
* Auto-load testing patch for appropriate Rails versions
* Figure out dev environment reloading.
* Rename controllers as resources? Generate into and load from app/resources.
* Add DSL for parameter typing. Virtus? Hide parameters behind strong typing accessors. Make `params` give deprecation warnings.
* Build up from AbstractController::Base instead of ActionController::Base. Drop HideActions and clean up #visible_action?.

## Installation

Add this line to your application's Gemfile:

    gem 'class_action'

And then execute:

    $ bundle

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
