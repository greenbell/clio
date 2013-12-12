module RailsAppHelper
  def rails_app_title
    "rails.#{params[:app].gsub("_", ".")}"
  end
end
