json.array!(@photos) do |photo|
  json.extract! photo, :id, :md5, :caption, :adult_content, :media_url
  json.url photo_url(photo, format: :json)
end
