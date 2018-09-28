# Setup sports application
namespace :sports do
	desc "Setup sports application"
	task :application_setup => :environment do
		beginning_time = Time.now
			Rake::Task['sunspot:solr:restart'].invoke
			Rake::Task['db:create'].invoke
			Rake::Task['db:migrate'].invoke
			Rake::Task['db:seed'].invoke
			Rake::Task['sports:create_metadata'].invoke
			Rake::Task['sports:upload_images'].invoke
			Rake::Task['sports:extract_and_feed_metadata'].invoke
			Rake::Task['sports:map_by_country'].invoke
			Rake::Task['sports:upload_equipment_images'].invoke
			Rake::Task['sports:upload_countries_flag_images'].invoke
			Rake::Task['assets:precompile'].invoke
			Rake::Task['sunspot:reindex'].invoke
		end_time = Time.now
		puts "Time elapsed #{get_duration_hrs_and_mins((end_time - beginning_time)*1000)}!!"
	end
end


def get_duration_hrs_and_mins(milliseconds)
  return '' unless milliseconds

  hours, milliseconds   = milliseconds.divmod(1000 * 60 * 60)
  minutes, milliseconds = milliseconds.divmod(1000 * 60)
  seconds, milliseconds = milliseconds.divmod(1000)
  "#{hours}h #{minutes}m #{seconds}s"
end
