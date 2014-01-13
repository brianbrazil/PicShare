class Media
  include Mongoid::Document

  field :uuid
  field :md5
  field :caption
  field :adult_content, type: Mongoid::Boolean
end
