class Search
  RESOURCES = %w(User Question Answer Comment)

  def self.search(query, resource, options = {})
    return unless query.present?
    escaped_query = Riddle::Query.escape(query)
    klass = resource.constantize if resource.in?(RESOURCES)

    ThinkingSphinx.search escaped_query, { classes: [klass] }.merge(options)
  end
end
