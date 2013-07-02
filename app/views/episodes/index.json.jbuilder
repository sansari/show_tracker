json.array!(@episodes) do |episode|
  json.extract! episode, :show_id, :season, :number, :name, :description, :url
  json.url episode_url(episode, format: :json)
end
