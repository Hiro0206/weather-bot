BASE_URL = "http://api.openweathermap.org/data/2.5/forecast".freeze

require "json"
require "open-uri"
require "dotenv/load"

# json_state = JSON::State.from_state(space_before: "   ")
# json_state.class
# json_state.indent
response = URI.open BASE_URL + "?zip=673-0877,JP&APPID=" + ENV["API_KEY"]
w_hash = JSON.parse(response.read)
weather = JSON.pretty_generate(w_hash)
puts weather
File.open("weather.json", mode = "w") do |f|
  f.print weather
end
puts w_hash["cod"]
puts w_hash["list"][0]["dt"]
