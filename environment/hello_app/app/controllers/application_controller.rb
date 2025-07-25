class ApplicationController < ActionController::Base
  def hello
    render html: "¡Hola, mundo!"
  end

  def goodbye
    render html: "goodbye, world!"
  end

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
end
