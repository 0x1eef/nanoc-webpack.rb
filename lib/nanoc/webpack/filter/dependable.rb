# frozen_string_literal: true

class Nanoc::Webpack::Filter
  module Dependable
    def dependable(paths:, reject: nil)
      reject ||= proc {}
      [*paths].flat_map do |path|
        expand(path).flat_map do
          node = File.join(root, _1)
          File.directory?(node) ? dependable(paths: File.join(_1, "*"), reject:) : _1
        end
      end.compact
         .reject(&reject)
    end

    def expand(path)
      abs_path = File.join(Dir.getwd, root)
      glob_str = File.expand_path(File.join(abs_path, path))
      Dir.glob(glob_str).map { File.join("/", _1.sub(abs_path, "")) }
    end

    def root
      @root ||= begin
        nanoc = Ryo.from(config.each.to_h)
        source = nanoc.data_sources.find(&:content_dir)
        source&.content_dir || "content/"
      end
    end
  end
end
