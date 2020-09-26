require "thor"
require "tsks/storage"
require "tsks/request"

module Tsks
  class CLI < Thor
    @setup_folder = File.expand_path ENV["SETUP_FOLDER"] || "~/.tsks"

    def self.setup_folder
      @setup_folder
    end

    desc "init", "Setup tsks folder and storage"
    def init
      if File.directory? CLI.setup_folder
        return puts "tsks was already initialized."
      end

      Dir.mkdir CLI.setup_folder
      Tsks::Storage.init
    end

    desc "add TSK", "Add a new tsk (Use --context to specify one i.g. Work)"
    option :context
    def add tsk
      if !File.directory? CLI.setup_folder
        return puts "tsks was not initialized yet."
      end

      if options[:context]
        Tsks::Storage.insert tsk, options[:context]
      else
        Tsks::Storage.insert tsk
      end
    end

    desc "done ID", "Mark a tsk you have already done"
    def done id
      if !File.directory? CLI.setup_folder
        return puts "tsks was not initialized yet."
      end

      Tsks::Storage.update id
    end

    desc "list", "See all active tsks, filter by context or that are done"
    option :done, type: :boolean
    option :context
    def list
      if !File.directory? CLI.setup_folder
        return puts "tsks was not initialized yet."
      end

      tsks = nil

      if options[:done] && options[:context]
        tsks = Tsks::Storage.select_by({done: 1, context: options[:context]})
      elsif options[:done]
        tsks = Tsks::Storage.select_by({done: 1})
      elsif options[:context]
        tsks = Tsks::Storage.select_by({context: options[:context]})
      else
        tsks = Tsks::Storage.select_by({done: 0})
      end

      if tsks.count > 0
        for tsk in tsks
          puts "#{tsk[:id]} @#{tsk[:context]} #{tsk[:tsk]}"
        end
      else
        puts "No tsks found."
      end
    end

    desc "register", "Register an e-mail to be able to sync your tsks"
    option :email, required: true
    option :password, required: true
    def register
      if !File.directory? CLI.setup_folder
        return puts "tsks was not initialized yet."
      end

      res = Tsks::Request.post "/register", {email: options[:email],
                                             password: options[:password]}

      if res && res[:status_code] == 201
        File.write File.join(CLI.setup_folder, "token"), res[:token]
        puts "Succesfully registered."
      elsif res && res[:status_code] == 409
        puts "This e-mail is already registered."
      end
    end

    desc "login", "Login to be able to sync your tsks"
    option :email, required: true
    option :password, required: true
    def login
      if !File.directory? CLI.setup_folder
        return puts "tsks was not initialized yet."
      end

      res = Tsks::Request.post "/login", {email: options[:email],
                                          password: options[:password]}

      if res && res[:status_code] == 200
        File.write File.join(CLI.setup_folder, "token"), res[:token]
        puts "Succesfully logged in."
      elsif res && res[:status_code] == 403
        puts "Invalid e-mail or password."
      end
    end

    desc "sync", "Synchronize your tsks"
    def sync
      if !File.directory? CLI.setup_folder
        return puts "tsks was not initialized yet."
      end

      if !File.exist? File.join CLI.setup_folder, "token"
        return puts "Please, login before try to sync."
      end

      token = File.read File.join CLI.setup_folder, "token"
      get_res = Tsks::Request.get "/tsks", token
      local_tsks = Tsks::Storage.select_all

      if get_res && get_res[:status_code] == 200
        local_tsks_to_post = local_tsks - get_res[:tsks]
        Tsks::Request.post "/tsks", token, {tsks: local_tsks_to_post}
        remote_tsks_to_storage = get_res[:tsks] - local_tsks
        Tsks::Storage.insert_many remote_tsks_to_storage
        puts "Your tsks were succesfully synchronized."
      end
    end
  end
end
