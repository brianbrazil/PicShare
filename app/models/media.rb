class Media
  include Mongoid::Document

  field :md5
  field :caption
  field :media_url, type: String
  field :adult_content, type: Mongoid::Boolean
end
