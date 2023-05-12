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

  def ranks_grade(rank)
    rank = rank.round
    grading_by_words = %w(unrancked poor mediocre sterile good notbad lovely awesome!)
    grading_by_emoji = %w(🧭 ☠️ 🤧 🤐 😸 👾 🩸 🤩)

    ActiveSupport::SafeBuffer.new(grading_by_words[rank].capitalize) +
      content_tag(:span, grading_by_emoji[rank], class: "rank-emoji")
  end

end
