json.array!(@photos) do |photo|
  json.extract! photo, :id, :uuid, :md5, :caption, :adult_content, :url
  json.url photo_url(photo, format: :json)
end
