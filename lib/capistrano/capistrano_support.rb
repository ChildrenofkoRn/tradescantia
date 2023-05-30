module CapistranoSupport
  class FileNotFound < IOError; end

  module Checker
    def self.exist?(env)
      unless File.exist?(env)
        raise FileNotFound, "File not found: #{env}. its impossible to continue."
      end
      true
    end
  end
end

include CapistranoSupport
