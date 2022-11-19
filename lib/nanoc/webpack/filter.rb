# frozen_string_literal: true

##
# Compiles a textual nanoc item with webpack.
class Nanoc::Webpack::Filter < Nanoc::Filter
  include FileUtils

  identifier :webpack
  type :text
  always_outdated

  def run(content, options = {})
    webpack(temp_file(content))
  end

  private

  def webpack(file)
    system "node",
           "./node_modules/webpack/bin/webpack.js",
           "--entry", File.join(Dir.getwd, content_dir, item.identifier.to_s),
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

  def content_dir
    @content_dir ||= begin
      nanoc = Ryo.from(config.each.to_h)
      source = nanoc.data_sources.find(&:content_dir)
      source&.content_dir || "content/"
    end
  end
end
