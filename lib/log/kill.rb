class Kill
  attr_reader :killer_player, :killed_player, :kill_reason

  def initialize(killer_player, killed_player, kill_reason)
    @killer_player = killer_player
    @killed_player = killed_player
    @kill_reason = kill_reason
  end
end
