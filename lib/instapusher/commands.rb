require_relative "../instapusher"
require 'net/http'
require 'uri'

module Instapusher
  class Commands

    attr_reader :debug, :api_key, :branch_name, :project_name

    def initialize init_options = {}
      @debug = init_options[:debug]
      @quick = init_options[:quick]
      @local = init_options[:local]

      git          = Git.new
      @branch_name  = init_options[:project_name] || ENV['INSTAPUSHER_BRANCH'] || git.current_branch
      @project_name = init_options[:branch_name] || ENV['INSTAPUSHER_PROJECT'] || git.project_name
    end

    def deploy
      verify_api_key
      SpecialInstructionForProduction.new.run if production?

      submission = JobSubmission.new(debug, options)
      submission.submit_the_job

      if submission.success?
        submission.feedback_to_user
        TagTheRelease.new(branch_name, debug).tagit if production?
      else
        puts submission.error_message
      end
    end

    private

    def options
      @options ||= begin
        { project: project_name,
          branch:  branch_name,
          quick:   @quick,
          local:   @local,
          api_key: api_key }
      end
    end

    def verify_api_key
      @api_key = ENV['API_KEY'] || Instapusher::Configuration.api_key(debug) || ""

      if @api_key.to_s.length == 0
        abort "Please enter instapusher api_key at ~/.instapusher "
      elsif debug
        puts "api_key is #{@api_key}"
      end
    end

    def production?
      branch_name.intern != :production
    end

  end
end
