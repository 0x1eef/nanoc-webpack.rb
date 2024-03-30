# frozen_string_literal: true

##
# Compiles a nanoc item with webpack.
module Nanoc::Webpack
  class Filter < Nanoc::Filter
    require_relative "filter/dependable"
    require_relative "spawn"
    include Dependable
    include Spawn
    include FileUtils

    identifier :webpack
    type :text

    ##
    # @example
    #   Nanoc::Webpack.default_argv.replace ["--cache-type", "memory"]
    #
    # @return [Array<String>]
    #  The default command-line options forwarded to webpack.
    def self.default_argv
      @default_argv ||= ["--cache-type", "filesystem"]
    end

    ##
    # @param [String] content
    #  The contents of a file.
    #
    # @param [Hash] options
    #  A hash of options.
    #
    # @return [void]
    def run(content, options = {})
      options = Ryo.from(options)
      path    = temporary_file(content).path
      depend_on dependable(paths: options.depend_on, reject: options.reject)
                  .map { items[_1] }
      spawn "node",
            ["./node_modules/webpack/bin/webpack.js",
             "--entry", File.join(Dir.getwd, item.attributes[:content_filename]),
             "--output-path", File.dirname(path),
             "--output-filename", File.basename(path),
             *default_argv, *(options.argv || [])],
            log: File.join(tmpdir, "webpack.log")
      File.read(path)
    ensure
      rm(path)
    end

    private

    def default_argv
      self.class.default_argv
    end

    def temporary_file(content)
      mkdir_p(tmpdir)
      file = Tempfile.new(File.basename(item.identifier.to_s), tmpdir)
      file.write(content)
      file.tap(&:flush)
    end

    def tmpdir
      File.join(Dir.getwd, "tmp", "webpack")
    end
  end
end
