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
    #   Nanoc::Webpack.default_argv.concat ["--cache-type", "filesystem"]
    #
    # @return [Array<String>]
    #  The default command-line options forwarded to webpack.
    def self.default_argv
      @default_argv ||= []
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
      path = temporary_file(content).path
      depend_on dependable(paths: options.depend_on, reject: options.reject)
                  .map { items[_1] }
      argv = [*(options.argv || []), *default_argv]
      scan(argv)
      spawn "node",
            ["./node_modules/webpack/bin/webpack.js",
             *argv,
             "--entry", File.join(Dir.getwd, item.attributes[:content_filename]),
             "--output-path", File.dirname(path),
             "--output-filename", File.basename(path)],
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

    def scan(argv)
      options = argv.filter_map { _1.start_with?("-") ? _1 : nil }
      builtins = %w[--entry --output-path --output-filename]
      options
        .map { |option| [option, options.count { _1 == option }] }
        .each do |option, count|
        if builtins.include?(option)
          abort log("[fatal] '#{option}' is a builtin option that can't be replaced")
        elsif count > 1
          warn log("[warn] '#{option}' appears in argv more than once")
        end
      end
    end

    def log(message)
      "[nanoc-webpack.rb] #{message}"
    end
  end
end
