require 'log/build_parser'

module Main
  class << self
    def process(*args)
      puts BuildParser.process(args)
      #puts args
    end
  end
end

Main.process('-g', 'game_1')
Main.process('-k', 'game_1')
Main.process('-h')


