module Instapusher
  class Git
    def current_branch
      result = %x{git branch}.split("\n")
      if result.empty?
        raise "It seems your app is not a git repo"
      else
        result.select { |b| b =~ /^\*/ }.first.split(" ").last.strip
      end
    end

    def current_user
      `git config user.name`.chop!
    end

    def project_name
      `git config remote.origin.url`.chop!.scan(/\/([^\/]+).git$/).flatten.first
    end
  end
end
