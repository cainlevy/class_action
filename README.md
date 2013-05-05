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

The spaghetti of `:only` and `:except` options for controller filters go away. Each filter should be declared on only the action classes that use it.

Logic that checks the request's verb is considered an anti-pattern. Instead, create a separate action for each verb.

Logic that checks the current controller and action names is also considered an anti-pattern. Instead, include the logic into only the controller actions that use it.

Instead of passing ivar assigns, the view can reference the controller as a light-weight view object.

unimplemented: Parameters can be strongly typed with a declarative DSL. This could be extended to generate documentation.

## Keeping DRY

Each action class will include two modules:
* The controller module (e.g. `FoosController` itself), for concerns that apply to each action on the resource.
* A global ApplicationConcerns module for concerns that apply across the entire application. (This could've been named ApplicationController, but it would complicate transitioning mature codebases.)

## RESTful archetypes and VERB actions

The base classes inherit from `ActionController::Base` for each HTTP verb. Your application might customize these with behavior specific to certain verbs, such as `protect_from_forgery`.

* [GETAction]
* [POSTAction]
* [PUTAction]
* [DELETEAction]

A set of common RESTful archetypes may be subclassed. Each archetype includes default logic for a bare-bones simple pattern, but could reasonably be customized for your application's own custom patterns.

* [IndexAction]
* [ShowAction]
* [NewAction]
* [CreateAction]
* [EditAction]
* [UpdateAction]
* [DeleteAction]
* [DestroyAction]

## TODO

* Figure out dev environment reloading.
* Add DSL for parameter typing.
* Build up from AbstractController::Base instead of ActionController::Base.

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
