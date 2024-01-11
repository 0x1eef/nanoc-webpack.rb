# frozen_string_literal: true

##
# Compiles a textual nanoc item with webpack.
class Nanoc::Webpack::Filter < Nanoc::Filter
  require_relative "filter/dependable"
  Error = Class.new(RuntimeError)
  include FileUtils
  include Dependable

  identifier :webpack
  type :text

  ##
  # @return [Hash]
  #  Returns the default command-line options given
  #  to the webpack executable.
  def self.default_options
    @default_options ||= {}
  end

  def run(content, options = {})
    depend_on dependable(paths: options[:depend_on], reject: options[:reject])
              .map { items[_1] }
    webpack temporary_file_for(content),
            args: self.class.default_options.merge(options[:args] || {})
  end

  private

  def webpack(file, args: {})
    sh "node",
       "./node_modules/webpack/bin/webpack.js",
       "--entry", File.join(Dir.getwd, item.attributes[:content_filename]),
       "--output-path", File.dirname(file.path),
       "--output-filename", File.basename(file.path),
       *webpack_args(args)
    if $?.success?
      File.read(file.path).tap { file.tap(&:unlink).close }
    else
      rm_f Dir.glob(File.join(File.dirname(file.path), "*"))
      file.close
      raise Error, "webpack.js exited unsuccessfully (exit code: #{$?.exitstatus})", []
    end
  end

  def webpack_args(args)
    args.each_with_object([]) do |(key, value), ary|
      if value.equal?(true)
        ary << key
      else
        ary.concat [key, value.to_s]
      end
    end
  end

  def temporary_file_for(content)
    dir = File.join(Dir.getwd, "tmp", "nanoc-webpack.rb")
    mkdir_p(dir) unless Dir.exist?(dir)
    file = Tempfile.new(File.basename(item.identifier.to_s), dir)
    file.write(content)
    file.tap(&:flush)
  end

  def sh(*args)
    print "webpack: ", args.join(" "), "\n"
  end
end
