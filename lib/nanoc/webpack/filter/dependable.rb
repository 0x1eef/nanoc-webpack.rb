# frozen_string_literal: true

module Nanoc::Webpack::Filter::Dependable
  def dependable(paths:)
    [*paths].flat_map do |path|
      expand(path).map { items[_1] }
    end.compact
  end

  def expand(path)
    abs_path = File.join(Dir.getwd, content_dir)
    glob_str = File.expand_path(File.join(abs_path, path))
    Dir.glob(glob_str).map { _1.sub(abs_path, "").prepend("/") }
  end

  def content_dir
    @content_dir ||= begin
      nanoc = Ryo.from(config.each.to_h)
      source = nanoc.data_sources.find(&:content_dir)
      source&.content_dir || "content/"
    end
  end
end
