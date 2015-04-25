require "run_later/version"
require "thor"
require 'yaml'
require 'fileutils'


module RunLater
  
  class CLI  < Thor     
    default_task :queue
    desc "queue", "Queue commands"
    method_option :commands, :type => :string, :required => true
    def queue
      FileUtils.mkdir_p(defaults[:root]) unless File.directory?(defaults[:root])
        
      open(defaults[:file], 'a+') do |f|
        f.puts options[:commands]
        say "Adding `#{options[:commands]}`", :green
      end
    end

    desc "perform!", "Perform and save log"
    def perform!
      log = "#{@log}_#{Time.now.to_i}"
      
      open(log, 'w+') do |f|
        open(defaults[:file], 'r').each_line do |command|
          f.puts `#{command}`
        end
      end
    end


private
def defaults
  root = File.join(ENV['HOME'], '.run_later')
  
  {
    root: File.join(ENV['HOME'], '.run_later'),
    file: File.join(root, 'commands'),
    log: File.join(root, 'log')
  }
end
  
  
      
  end
end


# ruby -Ilib ./bin/run_later --commands="ls -la && pwd" 
