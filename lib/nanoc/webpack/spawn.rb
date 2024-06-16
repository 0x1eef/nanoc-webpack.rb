# frozen_string_literal: true

module Nanoc::Webpack
  module Spawn
    require "test-cmd"
    Error = Class.new(RuntimeError)

    ##
    # Spawns a process
    #
    # @param [String] exe
    #  The path to an executable
    #
    # @param [Array<String>] argv
    #  An array of command line arguments
    #
    # @return [Integer]
    #  Returns the exit code of the spawned process
    def spawn(exe, argv)
      r = cmd(exe, *argv)
      if r.success?
        r.exit_status
      else
        raise Error,
              "#{File.basename(exe)} exited unsuccessfully\n" \
              "(item: #{item.identifier})\n" \
              "(exit code: #{r.exit_status})\n" \
              "(stdout: #{r.stdout.gsub(Dir.getwd, "")[1..]&.chomp})\n" \
              "(stderr: #{r.stderr.gsub(Dir.getwd, "")[1..]&.chomp})\n",
              []
      end
    end
  end
end
