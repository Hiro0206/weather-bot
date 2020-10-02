require "open-uri"
require "zlib"
require "json"
require "dotenv/load"

city_url = "http://bulk.openweathermap.org/sample/city.list.json.gz"
city_file = "city_list_jp.json"

def retrieveCityData
  URI.open city_url do |file|
    Zlib::GzipReader.open(file) do |gz|
      open(city_file, "w") do |out|
        array = []
        w_hash = JSON.parse(gz.read, symbolize_names: true)
        w_hash.each do |hash|
          if hash[:country] == "JP"
            array << hash
          end
        end
        out.puts(JSON.pretty_generate(array))
      end
    end
  end
end

def findWeatherData
  weather_url = "http://api.openweathermap.org/data/2.5/weather?lang=ja&units=metric&APPID=" + ENV["API_KEY"] + "&id="
  weather_file = "weather.json"
  URI.open weather_url + "1850147" do |res|
    open(weather_file, "w") do |out|
      array = []
      w_hash = JSON.parse(res.read, symbolize_names: true)
      print weather = w_hash[:name] + ":" + w_hash[:weather][0][:main] + w_hash[:main][:temp_min].to_s
      out.puts(JSON.pretty_generate(w_hash))
    end
  end
end

findWeatherData
