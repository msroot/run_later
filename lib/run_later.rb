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
      initialize_directory!
      
      open(defaults[:file], 'a+') do |f|
        f.puts options[:commands]
        say "Adding `#{options[:commands]}`", :green
      end
    end

    desc "perform", "Perform and save log"
    def perform
      say "Not file found #{defaults[:file]}", :red and return unless file_exist?
      
      log = defaults[:log]
      
        open(defaults[:file], 'r').each_line do |command|
          # _command = IO.popen("#{command}") { |f| puts f.gets }
          say "Running #{command}"
          
          system("echo $(""#{command}"") >> #{log}")
      end
      say "Done! Log saved in #{log}", :green
    end


    private
    def defaults
      root = File.join(ENV['HOME'], '.run_later')
  
      {
        root: File.join(ENV['HOME'], '.run_later'),
        file: File.join(root, 'commands'),
        log: File.join(root, "log_#{Time.now.to_i}")
      }
    end
  
    def file_exist?
      File.exist? defaults[:file]
    end
    
    def initialize_directory!
      FileUtils.mkdir_p(defaults[:root]) unless File.directory?(defaults[:root])
    end  
      
  end
end


# ruby -Ilib ./bin/run_later --commands="dev && cd ~/Development && ls -la | grep rails" 
# ruby -Ilib ./bin/run_later perform


# First, note that when Ruby calls out to a shell, it typically calls to /bin/sh, not Bash.
# Some Bash syntax is not supported by /bin/sh on all systems.

# http://stackoverflow.com/questions/2232/calling-shell-commands-from-ruby