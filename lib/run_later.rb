require "run_later/version"
require "thor"
require 'yaml'
require 'fileutils'



module RunLater
  
  class CLI  < Thor     
    default_task :queue
    
    desc "queue", "Queue commands"
    method_option :commands, :type => :string, :required => true, :alias=> :c
    method_option :preload, :type => :array, :alias=> :p,:default => [ "~/.profile",  "~/.bash_profile"]
    def queue
      initialize_files!
      commands = get_commands
      commands << options
      
      open(defaults[:commands], 'w') do |f|
        f.write commands.to_yaml
        say "Adding `#{options[:commands]}`", :green
      end
    end

    desc "perform", "Perform and save log"
    def perform

      say "Script not found #{defaults[:commands]}", :red and return unless commands_exist?

      log = defaults[:log]

      shell = IO.popen("/bin/bash", "w")

      shell.puts("echo #{Time.now} >> #{log}")
      
      get_commands.map{ |command|
        
        command[:preload].each {|source|
          say "Loading: #{source}", :green
          shell.puts("source #{source}")        
        }

        
        say "Running: #{command[:commands]}", :yellow
        shell.puts("sudo #{command[:commands]} >> #{log}")
      }

      say "Done! Log saved in #{log}", :green
    end
    

    desc "clean", "clean"
    def clean
      `rm -rf #{defaults[:root]}`
    end
  
    desc "list", "list commands"
    def list
      initialize_files!
      say get_commands
    end
    
    private

    def defaults
      root = File.join(ENV['HOME'], '.run_later')
      
      {
        root: root,
        commands: File.join(root, 'commands.yaml'),
        log: File.join(root, "run_later.log")
      }
    end
  
    def get_commands
      YAML::load_file defaults[:commands]
    end
    
    def commands_exist?
      File.exist? defaults[:commands]
    end
  
    def initialize_files!
      FileUtils.mkdir_p(defaults[:root]) unless File.directory? defaults[:root]

      File.open(defaults[:commands], "w") do |file|
        file.write [].to_yaml
      end unless commands_exist?
      
    end  
      
  end
end
