require_relative './timetrap_everhour/version'
require_relative './timetrap_everhour/config'
require_relative './timetrap_everhour/client'
require_relative './timetrap_everhour/entries_parser'

require 'pry'
require 'whirly'
require 'time_diff'
require 'highline'

begin
  Module.const_get('Timetrap')
rescue NameError
  module Timetrap;
    module Formatters; end
    Config = { 'everhour' => { 'aliases' => {} } }
  end
end

class Timetrap::Formatters::Everhour
  def initialize(entries)
    @entries = entries
  end

  def output
    cli = HighLine.new
    client = TimetrapEverhour::Client.new

    Whirly.start color: true, spinner: "dots", status:  "Fetching data from everhour ...", stop: Paint["✓", :green]
    tasks = client.tasks
    Whirly.stop

    parser = TimetrapEverhour::EntriesParser.new(
      entries: entries,
      tasks: tasks,
      alias_map: TimetrapEverhour::Config.instance.aliases
    )

    payloads = parser.payloads

    if payloads.length <= 0
      puts "Nothing to report."
      return
    end

    puts "The following entries will be submitted:\n"

    payloads.each do |payload|
      puts " * #{Paint[payload[:human_duration], :green]} \"#{Paint[payload[:name], :bold]}\" at #{payload[:date]}"
    end

    # TODO show a summary

    confirm = cli.ask("Submit entries to everhour?  (type: yes)")

    if confirm == "yes"
      Whirly.start color: true, spinner: "dots", status:  "Submitting ...", stop: Paint["✓", :green]
        payloads.each do |payload|
          response = client.add_time(
            task_id: payload[:task_id],
            date: payload[:date],
            time: payload[:seconds]
          )

          sleep 0.5
        end
      Whirly.stop
    end
  end

  private

  attr_reader :entries
end
