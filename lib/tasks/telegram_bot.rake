task :telegram_bot => :environment do
	puts "*************** HELLO FROM TELEGRAM BOT ***************"
	require 'telegram/bot'

	token 		= ENV['TELEGRAM_TOKEN']
	base_url 	= 'http://rubygems.org/api/v1/versions'

	Telegram::Bot::Client.run(token) do |bot|
		bot.listen do |message|
			msg 		= message.text
			chat_id 	= message.chat.id
			user 		= message.from
			user_fname 	= user.try(:first_name)
			user_name 	= user.try(:username)
			puts "MESSAGE FROM #{user_fname} (#{user_name}): #{msg}"

			if msg == '/start'
				bot.api.send_message(chat_id: chat_id, text: "Please enter gem name. Example:\ngem devise")
			elsif msg.present? && msg.include?("gem ") # use .present? to prevent nil:NilClass on .include? method
				g = msg.split.last
				json 		= HTTParty.get("#{base_url}/#{g}/latest.json")
				version 	= json['version']
				if version == 'unknown'
					bot.api.send_message(chat_id: chat_id, text: "#{g} gem not found. Please try again")
				else
					bot.api.send_message(chat_id: chat_id, text: "#{g} gem latest version is #{version}")
				end
			else
				bot.api.send_message(chat_id: chat_id, text: "Please try again. Example:\ngem devise")
			end

		end
	end

end
