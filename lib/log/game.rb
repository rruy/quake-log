require 'json'
require_relative 'kill'
require_relative 'player'

class Game
  attr_reader :name, :players, :kills, :total_kills

  def initialize(name)
    @name = name
    @kills = []
    @players = []
    @total_kills = []
  end

  def add_player(player_name)
    find_player_by_name(player_name) || create_player(player_name)
  end

  def kill_player(killer, killed, kill_reason)
    killer_player = add_player(killer)
    killed_player = add_player(killed)

    killer_player.kill(killed_player)

    @kills << Kill.new(killer_player, killed_player, kill_reason)
  end

  def to_hash
    score_info = {}

    players_in_game.each do |player|
      score_info[player.name] = player.score
    end

    { @name => { total_kills: @kills.length,
                 players: players_names,
                 kills: score_info } }
  end

  def to_s
    JSON.pretty_generate(to_hash)
  end

  def kill_reasons_to_hash
    kill_reasons = {}

    @kills.each do |kill|
      kill_reasons[kill.kill_reason] ||= 0
      kill_reasons[kill.kill_reason] += 1
    end

    { @name => { kill_by_means: kill_reasons } }
  end

  def killed_reasons
    JSON.pretty_generate(kill_reasons_to_hash)
  end

  def find_player_by_name(name)
    @players.detect { |player| player.name == name }
  end

  private

  def players_names
    players_in_game.map(&:name)
  end

  def players_in_game
    @players.reject { |player| player.name == '<world>' }
  end

  def create_player(name)
    player = Player.new(name)
    @players << player
    player
  end
end
