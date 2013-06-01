require 'class_action/action'

module ClassAction
  class GETAction < ActionController::Base
    include ClassAction::Action
  end
  class POSTAction < ActionController::Base
    include ClassAction::Action
    protect_from_forgery
  end
  class PUTAction < ActionController::Base
    include ClassAction::Action
    protect_from_forgery
  end
  class DELETEAction < ActionController::Base
    include ClassAction::Action
    protect_from_forgery
  end
end
