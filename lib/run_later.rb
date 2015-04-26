#   MIT License Copyright (c) 2015 Ioannis Kolovos
#   See License
#
#   RunLater is a gem for running commands later.
#   It saves the commands in a yaml file (`~/.run_later/commands.yaml`) and executed it when you call `perform`
#
#   Usage:
#
#   $ run_later queue --commands='brew upgrade && brew install phantomjs'
#
#   Later:
#
#   $  run_later perform
#
#   Methods:
#       
#   $ run_later queue params # Adding commands 
#   $ run_later clean # remove ~/.run_later
#   $ run_later perform # executes the queue
#   $ run_later list # view queue
#    
#    For more details use: 
#      
#   $ run_later help
#
#
#   Sourcing: 
#
#   When you running system commands with Ruby, is using `sh`  so you have to load  sources  like `~/.profile` or `.~/.bash_profile`
#   Default loaded are: ["~/.profile", "~/.bash_profile"]
#
#
#   Options:
#
#
#   --commands='brew upgrade && brew install phantomjs'  # Commands to execute
#   --preload=~/.bash_profile ~/.rvmrc                   # Source files to be loaded before execution (separated by space)
#                                                        # Default: ["~/.profile", "~/.bash_profile"]
#   --sudo, --no-sudo                                    # If commands require sudo
#   --env=foo:bar joe:doe                                # System variables to be set before execution (key:value separated by space)
#
#
#   Example:
#   $ run_later --commands='brew upgrade && brew install phantomjs' --sudo  --env=foo:bar joe:doe --preload=~/.bash_profile ~/.rvmrc  
# 
#


require "run_later/version"
require "thor"
require 'yaml'
require 'fileutils'



module RunLater
  
  class CLI  < Thor     
    default_task :queue
    
    desc "queue", "Queue commands"
    
    method_option :commands, 
    :type => :string, 
    :alias=> :c,
    :required => true, 
    :banner => "'brew upgrade && brew install phantomjs'",
    :desc => "Commands to execute"
    
    method_option :preload, 
    :type => :array, 
    :alias=> :p, 
    :banner => "~/.bash_profile ~/.rvmrc", 
    :default => [ "~/.profile",  "~/.bash_profile"], 
    :desc => "Source files to be loaded before execution (separated by space)"
    
    method_option :sudo, 
    :type => :boolean, 
    :default => false,
    :desc => "If commands require sudo"
    
    method_option :env, 
    :type => :hash, 
    :alias=> :e, 
    :banner => "foo:bar joe:doe",
    :desc => "System variables to be set before execution (key:value separated by space)"
    
    def queue
      initialize_files!
      commands = get_commands
      commands << options.merge({
        id: Time.now.to_i
      })
      
      say "Adding `#{options[:commands]}`", :green
      
      open(defaults[:commands], 'w') do |f|
        f.write commands.to_yaml
      end
    end

    desc "perform", "Perform and save log"
    def perform
      initialize_files!
      say "Empty", :green and return if get_commands.empty?

      log = defaults[:log]

      IO.popen("/bin/bash", "w") do |shell|

        shell.puts("echo #{Time.now} >> #{log}")
      
        get_commands.map{ |command|
          line = '--------------------------'
          
          say "#{line} Starting: #{Time.now} #{line}", :yellow
          
          say_status "ID",  command[:id]
          
          # load preloads
          command[:preload].each {|source|
            say_status "Loading:",  source
            # shell.puts("source #{source}")
            system("source #{source}")
          }
                
          # load env
          command[:env].each {|key, value|
            env = "#{key}=#{value}"
            say_status "Setting ENV", env
            system("export #{env}")
            # shell.puts("source #{source}")
            } unless command[:env].nil?
        
        
          say_status "Running", command[:commands], :yellow
          # shell.puts("sudo #{command[:commands]} >> #{log}")
          success = system("#{command[:commands]} >> #{log}")
          
          
          say_status 'Status', (success ? "🍺" : "😩" ), (success ? :green : :red)
          
        }

        say_status "Output saved", log,  :green

        
        
      end
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
      env = '/usr/bin/env'
      set = 'set'
      
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
