# frozen_string_literal: true

module FileHelper
  LOG_FILE_NAME = 'games.log'
  INIT_GAME_REGREX = /InitGame/.freeze
  END_GAME_REGREX = /-----/.freeze
  PLAYER_REGREX = /ClientUserinfoChanged: \d n\\(.*?)\\/.freeze
  KILL_REGREX = /Kill:.*:\s(.*)\skilled\s(.*)\sby\s(.*)/.freeze

  def log_file_path
    File.expand_path("../../data/#{LOG_FILE_NAME}", __FILE__)
  end

  def read_by_filename(filename)
    file = File.open(filename, 'r')
    yield file if block_given?
  rescue Errno::ENOENT => e
    puts "File not found: #{filename}"
    raise e
  rescue Errno::EACCES => e
    puts "Permission denied: #{filename}"
    raise e
  rescue StandardError => e
    puts "IO error: #{e.message}"
    raise e
  ensure
    file&.close
  end

  def game_start?(line)
    line =~ INIT_GAME_REGREX ? true : false
  end

  def game_over?(line)
    line =~ END_GAME_REGREX ? true : false
  end

  def player_line?(line)
    line =~ PLAYER_REGREX ? true : false
  end

  def player_name(line)
    line =~ PLAYER_REGREX
    Regexp.last_match(1)
  end

  def kill_event?(line)
    line =~ KILL_REGREX ? true : false
  end

  def kill_by_event(line)
    line =~ KILL_REGREX
    killer_player = Regexp.last_match(1)
    killed_player = Regexp.last_match(2)
    kill_reason = Regexp.last_match(3)

    [killer_player, killed_player, kill_reason]
  end
end
