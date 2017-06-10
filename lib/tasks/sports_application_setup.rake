# Setup sports application
namespace :sports do
	desc "Setup sports application"
	task :application_setup => :environment do
		beginning_time = Time.now
			Rake::Task["sunspot:solr:start"].invoke
			Rake::Task["db:seed"].invoke
			Rake::Task["sports:create_metadata"].invoke
			Rake::Task["sports:upload_images"].invoke
			Rake::Task["sports:extract_and_feed_metadata"].invoke
			Rake::Task["sports:map_by_country"].invoke
			Rake::Task["sports:upload_equipment_images"].invoke
			Rake::Task["sports:upload_countries_flag_images"].invoke
		end_time = Time.now
		puts "Time elapsed #{(end_time - beginning_time)*1000} milliseconds"
	end
end
