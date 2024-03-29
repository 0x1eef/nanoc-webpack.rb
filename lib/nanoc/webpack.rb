# frozen_string_literal: true

require "nanoc"
module Nanoc::Webpack
  require "ryo"
  require_relative "webpack/filter"
  ##
  # @example (see Nanoc::Webpack::Filter.default_argv)
  # @return (see Nanoc::Webpack::Filter.default_argv)
  def self.default_argv
    Nanoc::Webpack::Filter.default_argv
  end
end
