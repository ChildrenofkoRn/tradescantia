class SearchService
  ALLOW_TYPES = %w[review user].freeze

  def self.call(search_query:, search_type: nil)

    return [] if search_query.blank?

    query_safe = ThinkingSphinx::Query.escape(search_query)

    type = ALLOW_TYPES.include?(search_type) ? get_klass(search_type) : ThinkingSphinx

    type.search(query_safe)
  end

  private

  def self.get_klass(type)
    Object.const_get(type.capitalize)
  end

end
