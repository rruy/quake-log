# frozen_string_literal: true

class Player
  attr_accessor :name, :kill_times, :no_death_times, :death_times

  def initialize(name)
    @name = name
    @kill_times = 0
    @no_death_times = 0
    @death_times = 0
  end

  def kill(player)
    if common_player? player
      player.death_times += 1
    else
      @kill_times += 1
      player.no_death_times += 1
    end
  end

  def common_player?(player)
    self == player || @name == '<world>'
  end

  def by_name
    detect { |player| player.name == name }
  end

  def score
    @kill_times - @death_times
  end

  def ==(other)
    other.name == @name
  end
end
