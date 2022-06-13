# frozen_string_literal: true

require_relative 'file_helper'
require_relative 'game'

class QuakeParser
  include FileHelper

  attr_reader :games, :options

  DEATH_CAUSES = %i[
    MOD_UNKNOWN
    MOD_SHOTGUN
    MOD_GAUNTLET
    MOD_MACHINEGUN
    MOD_GRENADE
    MOD_GRENADE_SPLASH
    MOD_ROCKET
    MOD_ROCKET_SPLASH
    MOD_PLASMA
    MOD_PLASMA_SPLASH
    MOD_RAILGUN
    MOD_LIGHTNING
    MOD_BFG
    MOD_BFG_SPLASH
    MOD_WATER
    MOD_SLIME
    MOD_LAVA
    MOD_CRUSH
    MOD_TELEFRAG
    MOD_FALLING
    MOD_SUICIDE
    MOD_TARGET_LASER
    MOD_TRIGGER_HURT
    MOD_NAIL
    MOD_CHAINGUN
    MOD_PROXIMITY_MINE
    MOD_KAMIKAZE
    MOD_JUICED
    MOD_GRAPPLE
  ].freeze

  def initialize(options)
    @options = options
    @games = []
    @current_game = nil
  end

  def process
    read_by_filename(log_file_path) do |file|
      file.each do |line|
        create_game if game_start?(line)
        create_player(line) if player_line?(line)
        create_kill(line) if kill_event?(line)

        if game_over?(line) && @current_game && !@games.include?(@current_game)
          @games << @current_game
        else
          next
        end
      end
    end

    if options[:kill_reason]
      killed_reasons(options[:game_name])
    else
      game_information(options[:game_name])
    end
  end

  def game_information(game_name)
    return find_game_by_name(game_name) if game_name

    @games
  end

  def killed_reasons(game_name)
    return find_game_by_name(game_name).killed_reasons if game_name

    output = []

    @games.each { |game| output << game.killed_reasons }
    output
  end

  def find_game_by_name(name)
    game = @games.detect { |g| g.name == name }
    return game if game

    "Error: Game #{name} not found."
  end

  def create_game
    game_name = "game_#{@games.length + 1}"
    @current_game = Game.new(game_name)
  end

  def create_player(line)
    player_name = player_name(line)
    @current_game.add_player(player_name)
  end

  def create_kill(line)
    killer, killed, kill_reason = kill_by_event(line)
    reason = kill_reason.to_sym

    kill_reason = :MOD_UNKNOWN unless DEATH_CAUSES.include?(reason)

    @current_game.kill_player(killer, killed, kill_reason)
  end
end
