module ApplicationHelper
  def render_flash(type)
    message = flash[type]
    unless message.blank?
      render(partial: 'flash', locals: {type: type, message: message})
    end
  end
end
