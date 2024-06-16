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
    # The default argv for webpack
    #
    # @example
    #   Nanoc::Webpack.default_argv.concat ["--cache-type", "filesystem"]
    #
    # @return [Array<String>]
    #  Default argv for webpack
    def self.default_argv
      @default_argv ||= []
    end

    ##
    # @param [String] content
    #  The contents of a file
    #
    # @param [Hash] options
    #  A hash of options
    #
    # @return [void]
    def run(content, options = {})
      options = Ryo.from(options)
      file = temporary_file(content)
      depend_on dependable(paths: options.depend_on, reject: options.reject)
                  .map { items[_1] }
      argv = [*(options.argv || []), *default_argv]
      scan(argv)
      spawn "node",
            ["./node_modules/webpack/bin/webpack.js",
             *argv,
             "--entry", File.join(Dir.getwd, item.attributes[:content_filename]),
             "--output-path", File.dirname(file.path),
             "--output-filename", File.basename(file.path)]
      File.read(file.path)
    ensure
      file ? file.tap(&:unlink).close : nil
    end

    private

    def default_argv
      self.class.default_argv
    end

    def temporary_file(content)
      tmpdir = File.join(Dir.getwd, "tmp", "webpack")
      name = item.identifier.to_s
      file = Tempfile.new(
        [File.basename(name), File.extname(name).sub(/\A\.(ts|tsx|jsx)\z/, ".js")],
        mkdir_p(tmpdir).last
      )
      file.write(content)
      file.tap(&:flush)
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
