json.array!(@files) do |file|
  json.extract! file, :name
end