class Media
  include Mongoid::Document

  field :id, type: String, default: ->{ _id.to_s }
  field :md5
  field :caption
  field :adult_content, type: Mongoid::Boolean
end
