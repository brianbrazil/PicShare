json.array!(@photos) do |photo|
  json.extract! photo, :name
end