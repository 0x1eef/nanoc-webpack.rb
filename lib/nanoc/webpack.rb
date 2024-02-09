# frozen_string_literal: true

require "nanoc"
module Nanoc::Webpack
  require "ryo"
  require_relative "webpack/filter"
  ##
  # @example (see Nanoc::Webpack::Filter.default_options)
  # @return (see Nanoc::Webpack::Filter.default_options)
  def self.default_options
    Nanoc::Webpack::Filter.default_options
  end
end
