class SearchSphinxService

  ALLOW_TYPES = {
    "site"    => ThinkingSphinx,
    "review"  => Review,
    "users"   => User,
  }.freeze

  def self.call(search_query:, search_type: nil, page: nil)

    return [] if search_query.blank?

    query_safe = ThinkingSphinx::Query.escape(search_query)

    type = ALLOW_TYPES.include?(search_type) ? ALLOW_TYPES[search_type] : ThinkingSphinx

    type.search(query_safe, page: page, per_page: 10)
  end

end
