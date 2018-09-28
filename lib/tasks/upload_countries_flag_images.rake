namespace :sports do
	desc "Upload test single image !!"
	task :upload_countries_flag_images => :environment do
	## All Go cheat script ###
	countries_list = Country.all
	progress_bar = ProgressBar.new(countries_list.size)
	countries_list.each do |country|
			progress_bar.increment!
			# country = Country.first
			country_name = country.name.downcase.tr(' ', '_')
			# file: string, attachable_id: integer, attachable_type: string
			country_flag_image = Rails.root.join("db/country_flag_images/#{country_name}.gif")
			# puts sport_image
			if File.exist?(country_flag_image)
				country.attachment.destroy if country.attachment.present?
				options =  { attachable_id: country.id,
					attachable_type: country.class.name,
					file: country_flag_image.open
				}
				begin
					country.attachment = Attachment.create(options)
					# puts "Country flag attachment added successfully for '#{country_name}' country!!"
				rescue => error
					# puts "Error migrating Attachment: #{error}"
				end
			else
				# puts "File not found for #{country_name}"
			end
		end
	end
end
