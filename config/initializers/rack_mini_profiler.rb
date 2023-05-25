if Rails.env.development? || Rails.env.staging?
  # change position rack-mini-profiler
  Rack::MiniProfiler.config.position = 'bottom-right'
  # Have Mini Profiler start in hidden mode - display with short cut (defaulted to 'Alt+P')
  Rack::MiniProfiler.config.start_hidden = false
  Rack::MiniProfiler.config.authorization_mode = :allow_all
end
