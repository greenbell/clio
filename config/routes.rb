Clio::Application.routes.draw do
  root :to => "top#index"
  get ':controller(/:session)', :action => :index, :as => "log"
end
