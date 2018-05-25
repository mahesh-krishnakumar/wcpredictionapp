module DeviseHelper
  def devise_login_error_messages!
    flash_alerts = []

    if !flash.empty?
      flash_alerts.push(flash[:error]) if flash[:error]
      flash_alerts.push(flash[:alert]) if flash[:alert]
      flash_alerts.push(flash[:notice]) if flash[:notice]
    end

    return "" if flash_alerts.empty?
    messages = flash_alerts.map { |msg| content_tag(:li, msg) }.join

    html = <<-HTML
    <div id="error_explanation" class="alert alert-danger login-form__error-box">
      <ul class="mb-0 pl-3">#{messages}</ul>
    </div>
    HTML

    html.html_safe
  end
end