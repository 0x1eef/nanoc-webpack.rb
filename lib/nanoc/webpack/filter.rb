# frozen_string_literal: true

##
# Compiles a textual nanoc item with webpack.
class Nanoc::Webpack::Filter < Nanoc::Filter
  require_relative "filter/dependable"
  include FileUtils
  include Dependable

  identifier :webpack
  type :text

  def run(content, options = {})
    depend_on dependable(paths: options[:depend_on])
    webpack(temp_file(content))
  end

  private

  def webpack(file)
    system "node",
           "./node_modules/webpack/bin/webpack.js",
           "--entry", File.join(Dir.getwd, item.attributes[:content_filename]),
           "--output-path", File.dirname(file.path),
           "--output-filename", File.basename(file.path)
    if $?.success?
      File.read(file.path).tap { file.tap(&:unlink).close }
    else
      file.tap(&:unlink).close
      exit!($?.exitstatus)
    end
  end

  def temp_file(content)
    dir = File.join(Dir.getwd, "tmp", "webpack")
    mkdir_p(dir) unless Dir.exist?(dir)
    file = Tempfile.new(File.basename(item.identifier.to_s), dir)
    file.write(content)
    file.tap(&:flush)
  end
end
