module DeviseHelper
  def devise_error_messages!
    p 'whaaat = ' + resource.errors.full_messages.join('<br />')
    resource.errors.full_messages.join('<br />')
  end
end