require "open-uri"
require "zlib"
require "json"
require "dotenv/load" if development?
url = "http://bulk.openweathermap.org/sample/city.list.json.gz"
filename = "city_list_jp.json"

URI.open url do |file|
  Zlib::GzipReader.open(file) do |gz|
    open(filename, "w") do |out|
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
