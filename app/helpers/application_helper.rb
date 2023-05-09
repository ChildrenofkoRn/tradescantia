module ApplicationHelper
  ALERT_CLASSES = { success: 'success', notice: 'info', alert: 'danger' }
  DEFAULT_ALERT = 'info'

  def bootstrap_alert(alert)
    css_class = ALERT_CLASSES[alert.to_sym] || DEFAULT_ALERT
    "alert alert-#{css_class}"
  end


  def cache_hey_for_paginate(model_sym, page_number, total_pages)
    "#{model_sym.to_s.pluralize}/page-#{page_number}-total-#{total_pages}"
  end
end
