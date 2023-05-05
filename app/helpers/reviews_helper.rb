module ReviewsHelper

  def build_link(link)
    title = if @review.link.title.empty?
              @review.link.url.sub(/^https?\:\/\/(www.)?/, '')
            else
              @review.link.title
            end

    link_to title.truncate(70), @review.link.url, target: "_blank"
  end

  def ranks_grade(rank)
    grading = %w(unrancked🧭 poor☠️ mediocre🤧 sterile🤐 good😸 notbad👾 lovely🩸 awesome!🤩)
    grading[rank.round].capitalize
  end

end
