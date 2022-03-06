class Quote

  include Mongoid::Document
  include Mongoid::Timestamps

  field :quote, type: String
  field :author, type: String
  field :author_about, type: String
  field :tags, type: Array
end
