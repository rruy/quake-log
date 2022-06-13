require '../lib/log/player'

describe Player do
  let(:player1) { Player.new('player_1') }
  let(:player2) { Player.new('player_2') }
  let(:player3) { Player.new('<world>') }
  let(:player4) { Player.new('player_3') }
  let(:player5) { Player.new('player_1') }

  describe '#kill' do
    it 'should increase kill times when player kills another player' do
      player1.kill(player2)
      expect(player1.kill_times).to eq(1)
      expect(player2.no_death_times).to eq(1)
    end

    it 'should increase death times when player kills himself' do
      player1.kill(player1)
      expect(player1.death_times).to eq(1)
    end

    it 'should increase death times when player is killed by <world>' do
      player3.kill(player1)
      expect(player1.death_times).to eq(1)
    end
  end

  describe '#score' do
    it 'should return score equal is 0 when player has no kill events' do
      expect(player1.score).to eq(0)
    end

    it 'should return score when player has kill events' do
      expect(player4.score).to eq(0)
    end
  end

  describe '#==' do
    it 'should be true when comparing same player' do
      expect(player1).to be == player5
    end

    it 'should be false when comparing two players' do
      expect(player1).not_to be == player2
    end
  end

  describe '#common_player?' do
    it 'shoud return true when player is not a killer' do
      expect(player1.common_player?(player1)).to eq(true)
    end
  end
end
