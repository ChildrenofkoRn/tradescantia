class SearchSphinxService

  ALLOW_TYPES = {
    "site"    => ThinkingSphinx,
    "review"  => Review,
    "users"   => User,
  }.freeze

  def self.call(query:, type: nil, page: nil)

    return [] if query.blank?

    query_safe = ThinkingSphinx::Query.escape(query)

    klass = ALLOW_TYPES.include?(type) ? ALLOW_TYPES[type] : ThinkingSphinx

    results = klass.search(query_safe, page: page, per_page: 10)
    results.context[:panes] << ThinkingSphinx::Panes::ExcerptsPane
    results
  end

end
