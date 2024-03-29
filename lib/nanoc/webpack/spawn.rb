module Nanoc::Webpack
  module Spawn
    Error = Class.new(RuntimeError)
    def spawn(exe, argv, log:)
      Kernel.spawn(
        exe, *argv, { STDOUT => log, STDERR => log }
      )
      Process.wait
      unless $?.success?
        raise Error,
              "#{File.basename(exe)} exited unsuccessfully " \
              "(exit code: #{$?.exitstatus}, " \
              "item: #{item.identifier}, " \
              "log: #{log.gsub(Dir.getwd, '')[1..]})",
              []
      end
    end
  end
end
