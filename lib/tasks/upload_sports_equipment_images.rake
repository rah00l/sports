namespace :sports do
	desc "Upload equipment images !!"
	task :upload_equipment_images => :environment do
	## All Go cheat script ###
		equipments_list = Equipment.all
		progress_bar = ProgressBar.new(equipments_list.size)
		equipments_list[0..5].each do |equipment|
			progress_bar.increment!
			equipment_name = get_proper_equipment_name(equipment.name.downcase.tr(' ', '_'))
			# file: string, attachable_id: integer, attachable_type: string
			equipment_image = Rails.root.join("db/sports_equipment_images/#{equipment_name}.jpg")
			# puts sport_image
			if File.exist?(equipment_image) && equipment.description.present?
				equipment.attachments.destroy_all
				options =  { attachable_id: equipment.id, attachable_type: equipment.class, file: equipment_image.open }
				begin
					equipment.attachments = [ Attachment.create(options) ]
					# puts "Attachment added successfully for '#{equipment_name}' Equipment!!"
				rescue => error
					# puts "Error migrating Attachment: #{error}"
				end
			end
		end
	end
end

def get_proper_equipment_name(equipment)
	case equipment
	when 'basketball'
		'equipment_basketball'
	when 'football'
		'equipment_football'
	when 'baseball'
		'equipment_baseball'
	else
		equipment
	end
end