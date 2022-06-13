# frozen_string_literal: true

require '../lib/log/game'
require 'json'

describe Game do
  let(:game) { Game.new('game_1') }

  describe '#find_player_by_name' do
    it 'should return player when successfully created' do
      game.kill_player('test1', 'test2', 'MOD_RAILGUN')
      expect(game.find_player_by_name('test1')).to be_truthy
      expect(game.find_player_by_name('test2')).to be_truthy
    end

    it 'should return nil when parameter player is not correct or not exist in log file' do
      expect(game.find_player_by_name('test3')).to be_nil
    end
  end

  describe '#kill_player' do
    it 'should deal with no death kill event successfully' do
      game.kill_player('test1', 'test2', 'MOD_RAILGUN')
      player = game.find_player_by_name('test1')
      expect(player.kill_times).to eq(1)
      expect(player.no_death_times).to eq(0)
      expect(player.death_times).to eq(0)

      player = game.find_player_by_name('test2')
      expect(player.kill_times).to eq(0)
      expect(player.no_death_times).to eq(1)
      expect(player.death_times).to eq(0)
    end

    it 'should deal with kill by <world> event successfully' do
      game.kill_player('<world>', 'test3', 'MOD_TRIGGER_HURT')
      player = game.find_player_by_name('test3')
      expect(player.kill_times).to eq(0)
      expect(player.no_death_times).to eq(0)
      expect(player.death_times).to eq(1)
    end

    it 'should create kill by self event successfully' do
      game.kill_player('<world>', 'test4', 'MOD_TRIGGER_HURT')
      player = game.find_player_by_name('test4')
      expect(player.kill_times).to eq(0)
      expect(player.no_death_times).to eq(0)
      expect(player.death_times).to eq(1)
    end
  end

  describe '#to_hash' do
    it 'output the game information successfully' do
      expect_output_info = { 'game_1' => { total_kills: 0, players: [], kills: {} } }
      expect(game.to_hash).to eq(expect_output_info)

      # add no death times in kill event
      game.kill_player('test1', 'test2', 'MOD_RAILGUN')
      expect_output_info = { 'game_1' => { total_kills: 1,
                                           players: %w[test1 test2],
                                           kills: { 'test1' => 1, 'test2' => 0 } } }
      expect(game.to_hash).to eq(expect_output_info)

      # add a kill by <world> event
      game.kill_player('<world>', 'test1', 'MOD_TRIGGER_HURT')
      expect_output_info = { 'game_1' => { total_kills: 2,
                                           players: %w[test1 test2],
                                           kills: { 'test1' => 0, 'test2' => 0 } } }
      expect(game.to_hash).to eq(expect_output_info)

      # add a kill by self event
      game.kill_player('<world>', 'test2', 'MOD_TRIGGER_HURT')
      expect_output_info = { 'game_1' => { total_kills: 3,
                                           players: %w[test1 test2],
                                           kills: { 'test1' => 0, 'test2' => -1 } } }
      expect(game.to_hash).to eq(expect_output_info)
    end
  end

  describe '#killed_reasons' do
    it 'should return group by kill reasons successfully' do
      game.kill_player('test1', 'test2', 'MOD_RAILGUN')
      game.kill_player('<world>', 'test1', 'MOD_TRIGGER_HURT')
      game.kill_player('<world>', 'test2', 'MOD_ROCKET_SPLASH')
      game.kill_player('test4', 'test1', 'MOD_ROCKET_SPLASH')

      expect_info = JSON.pretty_generate({  'game_1' => { kill_by_means: { 'MOD_RAILGUN' => 1,
                                                                          'MOD_TRIGGER_HURT' => 1,
                                                                          'MOD_ROCKET_SPLASH' => 2 } } })

      expect(game.killed_reasons).to eq(expect_info)
    end

    it 'should return group by kill reasons with no kill events' do
      expect_info = JSON.pretty_generate({ 'game_1' => { kill_by_means: {} } })
      expect(game.killed_reasons).to eq(expect_info)
    end
  end
end
