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
      
      defaults[:file]
      
      # puts `#{defaults[:scripts]}  /bin/bash #{defaults[:file]} >> #{log}`

      
        open(defaults[:file], 'r').each_line do |line|
          say "Running command: #{line}", :yellow
          
          # puts `#{defaults[:scripts]} ./commands.sh  #{command} >> #{log}`
          next if line.start_with? '#'
          puts `eval$("#{line}") >> #{log}`
          
      end
      say "Done! Log saved in #{log}", :green
    end


    private
    def defaults
      root = File.join(ENV['HOME'], '.run_later')
  
      {
        root: File.join(ENV['HOME'], '.run_later'),
        file: File.join(root, 'commands.sh'),
        log: File.join(root, "run_later.log"),
        scripts: load_scripts
      }
    end
  
  
    def generate_command command
      
    end
    
    def load_scripts
       ["$HOME/.rvmrc", "$HOME/.profile"].map{|source|
          "source #{source} &&"
        }.join
    end
    def file_exist?
      File.exist? defaults[:file]
    end
    
    def initialize_directory!
      FileUtils.mkdir_p(defaults[:root]) unless File.directory?(defaults[:root])
    end  
      
  end
end


# ruby -Ilib ./bin/run_later --commands="[[ -s /Users/Ioannis/.profile ]] && source /Users/Ioannis/.profile"
# ruby -Ilib ./bin/run_later --commands="dev && cd ~/Development && ls -la | grep rails" 
# ruby -Ilib ./bin/run_later --commands="echo $PATH"
# ruby -Ilib ./bin/run_later perform
# First, note that when Ruby calls out to a shell, it typically calls to /bin/sh, not Bash.
# Some Bash syntax is not supported by /bin/sh on all systems.

# http://stackoverflow.com/questions/2232/calling-shell-commands-from-ruby
# http://tech.natemurray.com/2007/03/ruby-shell-commands.html