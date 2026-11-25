Rails.application.config.session_store :cookie_store,
  key: "_blog_backend_session",
  same_site: Rails.env.production? ? :none : :lax,
  secure: Rails.env.production?,
  httponly: true