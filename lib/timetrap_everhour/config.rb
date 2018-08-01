require 'singleton'

class TimetrapEverhour::Config
  include ::Singleton

  def initialize(timetrap_config = Timetrap::Config)
    @timetrap_config = timetrap_config
  end

  def api_key
    timetrap_config['everhour']['api_key']
  end

  def aliases
    timetrap_config['everhour']['aliases']
  end

  private

  attr_reader :timetrap_config
end
