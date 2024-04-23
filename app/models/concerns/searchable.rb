module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    mapping do
      indexes :body, type: 'text'
    end

    def self.search(query)
      params = {
        query: {
          bool: {
            should: [
              { match: { body: { query: query, operator: 'and', fuzziness: 2 } } },
              { wildcard: { body: { value: "*#{query}*" } } }
            ]
          }
        },
      }

      self.__elasticsearch__.search(params).records
    end
  end
end
