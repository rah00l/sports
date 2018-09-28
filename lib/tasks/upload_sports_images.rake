namespace :sports do
	desc "Upload sport images !!"
	task :upload_images => :environment do
	## All Go cheat script ###
		sports_list = Sport.all
		progress_bar = ProgressBar.new(sports_list.size)
		sports_list.each do |sport|
			progress_bar.increment!
			sport_name = sport.name.downcase.tr(' ', '_')
			# file: string, attachable_id: integer, attachable_type: string
			sport_image = Rails.root.join("db/sports_images/#{sport_name}.jpg")
			# puts sport_image
			if File.exist?(sport_image)
				sport.attachments.destroy_all
				options =  { attachable_id: sport.id, attachable_type: sport.class, file: sport_image.open }
				begin
					sport.attachments = [ Attachment.create(options) ]
					# puts "Attachment added successfully for '#{sport_name}' sport!!"
				rescue => error
					# puts "Error migrating Attachment: #{error}"
				end
			else
				# puts "File not found for #{sport_name}"
			end
		end
	end
end