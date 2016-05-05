require 'telegram/bot'

token 		= ENV['TELEGRAM_TOKEN']
base_url 	= 'http://rubygems.org/api/v1/versions'

Telegram::Bot::Client.run(token) do |bot|
	bot.listen do |message|
		msg 		= message.text
		chat_id 	= message.chat.id
		# user_name = message.from.first_name
		if msg.include?("gem ")
			g = msg.split.last
			json 		= HTTParty.get("#{base_url}/#{g}/latest.json")
			version 	= json['version']
			if version == 'unknown'
				bot.api.send_message(chat_id: chat_id, text: "#{g} gem not found. Please try again")
			else
				bot.api.send_message(chat_id: chat_id, text: "#{g} gem latest version is #{version}")
			end
		elsif msg == '/start'
			bot.api.send_message(chat_id: chat_id, text: "Please enter gem name. Example:\ngem devise")
		else
			bot.api.send_message(chat_id: chat_id, text: "Please try again. Example:\ngem devise")
		end

	end
end
