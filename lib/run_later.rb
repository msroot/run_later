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
          
          say "-------------------------- Starting: #{command[:id]} --------------------------", :yellow
          
          
          # load preloads
          command[:preload].each {|source|
            say "Loading: #{source}", :green
            # shell.puts("source #{source}")
            system("source #{source}")
          }
                
          # load env
          command[:env].each {|key, value|
            env = "#{key}=#{value}"
            say "Setting ENV: #{env}", :green
            system("export #{env}")
            # shell.puts("source #{source}")
          }
        
        
          say "Running: #{command[:commands]}", :yellow
          # shell.puts("sudo #{command[:commands]} >> #{log}")
          system("#{command[:commands]} >> #{log}")

        }

        say "Done! Log saved in #{log}", :green
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
