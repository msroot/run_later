require "run_later/version"
require "thor"
require 'yaml'
require 'fileutils'


module RunLater
  
  class CLI  < Thor     
    default_task :queue
    desc "queue", "Queue commands"
    def queue
      say "Currently under development", :green
      say "Check next version", :green
    end


  end
end
