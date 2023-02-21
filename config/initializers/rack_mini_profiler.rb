if ENV["development"]
  # change position rack-mini-profiler
  Rack::MiniProfiler.config.position = 'bottom-right'
  # Have Mini Profiler start in hidden mode - display with short cut (defaulted to 'Alt+P')
  Rack::MiniProfiler.config.start_hidden = true
end
