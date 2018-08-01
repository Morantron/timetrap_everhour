require 'date'
require 'uri'
require 'pry'

module TimetrapEverhour
  class EntriesParser
    def initialize(entries:, alias_map:, tasks:)
      @entries = entries
      @alias_map = alias_map
      @tasks = tasks
    end

    def payloads
      @payloads ||= entries.inject([]) do |memo, entry|
        set_current_task_id!(entry: entry)
        duration = duration_for(entry)

        next memo if current_task_id.nil?

        memo.push({
          task_id: current_task_id,
          seconds: duration,
          date: entry.values[:start].to_date.to_s,
          name: current_task["name"],
          human_duration: Time.diff(entry.values[:end], entry.values[:start], "%H %N")[:diff]
        })

        memo
      end
    end

    private

    def set_current_task_id!(entry:)
      note = entry.values[:note]

      task_alias = (note.match(/@\w+/) || [])[0]
      task_url = URI.extract(note).first

      if task_url
        @current_task_id = task_id_by_url(task_url)
      elsif task_alias
        @current_task_id = task_id_by_alias(task_alias)
      end
    end

    def task_id_by_alias(task_alias)
      alias_map.fetch(task_alias.to_sym)
    end

    def task_id_by_url(url)
      task = tasks.find { |t| t["url"] == url }
      task["id"] if task
    end

    def duration_for(entry)
      date_to_seconds(entry.values[:end]) - date_to_seconds(entry.values[:start])
    end

    def date_to_seconds(date)
      begin
        date.to_time.to_i
      rescue Exception => e
        binding.pry
      end
    end

    def current_task
      tasks.find { |t| t["id"] == current_task_id }
    end

    attr_reader :entries, :tasks, :alias_map, :current_task_id
  end
end
