json.array!(@shows) do |show|
  json.extract! show, :name, :description, :photo_url
  json.url show_url(show, format: :json)
end
