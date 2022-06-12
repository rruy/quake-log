class QuakeLog
  def self.process(args)
    QuakeParser.process(args)
  end
end

require 'log/quake_parser'
