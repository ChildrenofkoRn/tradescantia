module ReviewsHelper

  def build_link(link)
    title = if @review.link.title.empty?
              @review.link.url.sub(/^https?\:\/\/(www.)?/, '')
            else
              @review.link.title
            end

    link_to title.truncate(70), @review.link.url, target: "_blank"
  end

end
