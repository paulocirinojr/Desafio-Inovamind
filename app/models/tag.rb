class Tag
  include Mongoid::Document
  include Mongoid::Timestamps
  field :tag, type: String
end
