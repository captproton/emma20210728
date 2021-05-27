module ApplicationHelper
  include Pagy::Frontend
  def bootstrap_class_for(flash_type)
    {
      success: "alert-success",
      error: "alert-danger",
      alert: "alert-warning",
      notice: "alert-info"
    }.stringify_keys[flash_type.to_s] || flash_type.to_s
  end
  
  def avatar_path(object, options = {})
    size = options[:size] || 180
    default_image = options[:default] || "mp"
    base_url =  "https://secure.gravatar.com/avatar"
    base_url_params = "?s=#{size}&d=#{default_image}"
    
    if object.respond_to?(:avatar) && object.avatar.attached? && object.avatar.variable?
      object.avatar.variant(resize_to_fill: [size, size, { gravity: 'Center' }])
    elsif object.respond_to?(:email) && object.email
      gravatar_id = Digest::MD5::hexdigest(object.email.downcase)
      "#{base_url}/#{gravatar_id}#{base_url_params}"
    else
      "#{base_url}/00000000000000000000000000000000#{base_url_params}"
    end
  end

  def body_css_class
    @body_css_classes ||= []
    view_css_class = [controller_path.split('/')].flatten.join('-')

    @body_css_classes.unshift(view_css_class).join(' ')
  end

  def onboarding_step_icon(step_completed)
    colored_icon     = step_completed ? "fas fa-check-square text-success" : "far fa-square text-muted"
    filling   = step_completed ? "fas"          : "far"
    content_tag(:i, nil, class: "#{colored_icon}")

  end

  def link_to_edit_backstage_setting(step)
    target = step.classify.constantize.where("site_id IS NOT NULL").first
    model_name = target.class.to_s.underscore
    link_to step.titleize, send("edit_backstage_#{model_name}_path", target)
    # link_to edit_polymorphic_path(step)
    # link_to 'biography page', edit_backstage_biography_path(@biography), class:"btn btn-primary"

  end
  def link_to_new_step(step_model_name)
    step_path = step_model_name.tableize
    content_tag(:a, step_model_name, href: "/#{step_path}/new")
  end
end
