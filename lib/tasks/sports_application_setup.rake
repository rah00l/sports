# Setup sports application
namespace :sports do
	desc "Setup sports application"
	task :application_setup => :environment do
		Rake::Task["db:seed"].invoke
		Rake::Task["sports:create_metadata"].invoke
		Rake::Task["sports:upload_images"].invoke
		Rake::Task["sports:extract_and_feed_metadata"].invoke
		Rake::Task["sports:map_by_country"].invoke
		Rake::Task["sports:upload_equipment_images"].invoke
	end
end