# Quick start application
namespace :sports do
  desc "Setup sports application"
  task :quick_start_solr => :environment do
    beginning_time = Time.now
      Rake::Task["sunspot:solr:restart"].invoke
      Rake::Task["sunspot:reindex"].invoke
    end_time = Time.now
    puts "Time elapsed #{(end_time - beginning_time)*1000} milliseconds"
  end
end
