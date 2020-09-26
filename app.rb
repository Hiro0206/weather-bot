# app.rb
require "sinatra"
require "line/bot"
require "open-uri"
require "dotenv/load" if development?

def client
  @client ||= Line::Bot::Client.new do |config|
    config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
    config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
  end
end

def replyMessage(message, event)
  message = {
    type: "text",
    text: message,
  }
  client.reply_message(event["replyToken"], message)
end

def retrieveCityWeather(city_name)
  weather = nil
  weather_url = "http://api.openweathermap.org/data/2.5/forecast?APPID=" + ENV["API_KEY"] + "&id="
  File.open("city_list_jp.json", "r+:UTF-8") do |file|
    array = JSON.parse(file.read, symbolize_names: true)
    array.each_entry do |hash|
      next unless hash[:name] == city_name.chomp
      URI.open weather_url + hash[:id].to_s do |res|
        w_hash = JSON.parse(res.read, symbolize_names: true)
        weather = w_hash[:list][0][:weather][0][:main]
      end
    end
  end
  return weather
end

get "/" do
  "Hello, World!"
end

post "/callback" do
  body = request.body.read

  # signature = request.env["HTTP_X_LINE_SIGNATURE"]
  # error 400 do "Bad Request" end unless client.validate_signature(body, signature)

  events = client.parse_events_from(body)
  events.each do |event|
    case event
    when Line::Bot::Event::Message
      case event.type
      when Line::Bot::Event::MessageType::Text
        weather = retrieveCityWeather(event.message["text"])
        if weather.nil?
          replyMessage("入力された地名は日本には存在しません", event)
        else
          replyMessage(weather, event)
        end
      when Line::Bot::Event::MessageType::Image, Line::Bot::Event::MessageType::Video
        response = client.get_message_content(event.message["id"])
        tf = Tempfile.open("content")
        tf.write(response.body)
      end
    end
  end

  # Don't forget to return a successful response
  "OK"
end
