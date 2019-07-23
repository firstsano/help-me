module SphinxSearch
  CATEGORIES = %w[question answer comment user].freeze

  def self.search(query, category = nil, **options)
    options[:classes] = [category.classify.constantize] if CATEGORIES.include?(category)
    ThinkingSphinx.search query, **options
  end
end
