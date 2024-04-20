module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    mapping do
      indexes :body, type: 'text'
    end

    def self.search(query)
      puts query
      params = {
        query: {
          bool: {
            should: [
              {
                match: {
                  body: {
                    query: query,
                    operator: 'and',
                    fuzziness: 5,
                  },
                },
              },
              {
                wildcard: {
                  body: {
                    value: "*#{query}*",
                  },
                },
              },
            ],
          }
        },
      }

      self.__elasticsearch__.search(params).records.to_a
    end
  end
end
