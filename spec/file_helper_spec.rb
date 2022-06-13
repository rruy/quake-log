# frozen_string_literal: true

require '../lib/log/file_helper'

describe FileHelper do
  let(:extended_class) { Class.new { extend FileHelper } }

  describe '#read_by_filename' do
    it 'should raise error when file not found' do
      expect { extended_class.read_by_filename('invalid_file_path') }.to raise_error(Errno::ENOENT)
    end
  end

  describe '#game_start?' do
    it 'should be true when the line have string InitGame' do
      line = '00:00 InitGame: \sv_floodProtect\1\sv_maxPing\0\sv_minPing\0\sv_maxRate\10000\sv_minRate\0\sv_hostname\Code Miner Server\g_gametype\0\sv_privateClients\2\sv_maxclients\16\sv_allowDownload\0\dmflags\0\fraglimit\20\timelimit\15\g_maxGameClients\0\capturelimit\8\version\ioq3 1.36 linux-x86_64 Apr 12 2009\protocol\68\mapname\q3dm17\gamename\baseq3\g_needpass\0'
      expect(extended_class.game_start?(line)).to be true
    end

    it 'should be false when the line dont have string InitGame' do
      line = '00:02 ClientConnect: 2'
      expect(extended_class.game_start?(line)).to be false
    end
  end

  describe '#game_over?' do
    it 'should be true when line have separator to ending game' do
      line = ' 23:55 ------------------------------------------------------------'
      expect(extended_class.game_over?(line)).to be true
    end

    it 'should be false when line dont have separator to ending game' do
      line = '00:01 ClientConnect: 2'
      expect(extended_class.game_over?(line)).to be false
    end
  end

  describe '#player_line?' do
    it 'should be true when the line contains player information' do
      line = '00:51 ClientUserinfoChanged: 3 n\Dono da Bola\t\0\model\sarge/krusade\hmodel\sarge/krusade\g_redteam\\g_blueteam\\c1\5\c2\5\hc\95\w\0\l\0\tt\0\tl\0'
      expect(extended_class.player_line?(line)).to be true
    end

    it 'should be false when the line doesnt contain player info' do
      line = '00:00 Exit: Timelimit hit.'
      expect(extended_class.player_line?(line)).to be false
    end
  end

  describe '#player_name' do
    it 'should return player name when the line have correct info about player' do
      line = '21:51 ClientUserinfoChanged: 3 n\Dono da Bola\t\0\model\sarge/krusade\hmodel\sarge/krusade\g_redteam\\g_blueteam\\c1\5\c2\5\hc\95\w\0\l\0\tt\0\tl\0'
      player_name = extended_class.player_name(line)
      expect(player_name).to eq('Dono da Bola')
    end
  end

  describe '#kill_event?' do
    it 'should return true when the line is an killed event' do
      line = '00:42 Kill: 1022 2 22: <world> killed Isgalamido by MOD_TRIGGER_HURT'
      expect(extended_class.kill_event?(line)).to be true
    end

    it 'should return false when the line is not an killed event' do
      line = '00:50 Exit: Timelimit hit.'
      expect(extended_class.kill_event?(line)).to be false
    end
  end

  describe '#kill_by_event' do
    it 'should parse the killed event when line have correct information about killed' do
      line = '12:01 Kill: 1022 2 22: <world> killed Isgalamido by MOD_TRIGGER_HURT'
      killer, killed, kill_reason = extended_class.kill_by_event(line)
      expect(killer).to eq('<world>')
      expect(killed).to eq('Isgalamido')
      expect(kill_reason).to eq('MOD_TRIGGER_HURT')
    end
  end
end
