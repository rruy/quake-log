# frozen_string_literal: true

require 'optparse'
require 'quake_parser'

class BuildParser
  class << self
    def process(args)
      args = parse_args(args)
      QuakeParser.new(args).process
    end

    private

    def parse_args(args)
      options = {}

      opts = OptionParser.new do |argument|
        argument.banner = 'Usage: ruby main.rb [options]'
        argument.separator 'Specific options:'

        argument.on('-k', '--kill-reason', 'Output group by of kill reasons.') do
          options[:kill_reason] = true
        end

        argument.on('-g NAME', '--game-name Name', 'Output game info by name.') do |value|
          options[:game_name] = value
        end

        argument.separator 'Common options:'

        argument.on_tail('-h', '--help', 'Show this message.') do
          puts argument
          exit
        end
      end

      opts.parse!(args)
      options
    end
  end
end
