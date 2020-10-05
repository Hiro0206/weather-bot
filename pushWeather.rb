require "dotenv/load"
require "line/bot"

message = {
  type: "text",
  text: "これは実験メッセージだ！",
}

def client
  @client ||= Line::Bot::Client.new do |config|
    config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
    config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
  end
end

response = client.push_message("Ub08a2f0354e83ee4866d7a60985ec0ce", message)
p response
