require_relative '../lib/timetrap_everhour/entries_parser.rb'

describe TimetrapEverhour::EntriesParser do
  let :date_format do
    "%Y-%m-%d %H:%M:%S %z"
  end

  let :entries do
    [
      {:id=>1, :note=>"@task_one", :start=> "2018-07-23 10:00:00 +0200", :end=> "2018-07-23 13:30:00 +0200", :sheet=>"basa"},
      {:id=>2, :note=>"", :start=> "2018-07-24 15:00:00 +0200", :end=> "2018-07-24 16:00:00 +0200", :sheet=>"basa"},
      {:id=>3, :note=>"@task_two", :start=> "2018-07-25 09:00:00 +0200", :end=> "2018-07-25 10:00:00 +0200", :sheet=>"basa"},
      {:id=>4, :note=>"", :start=> "2018-07-27 13:00:00 +0200", :end=> "2018-07-27 14:00:00 +0200", :sheet=>"basa"},
      {:id=>5, :note=>"", :start=> "2018-07-28 15:00:00 +0200", :end=> "2018-07-28 16:00:00 +0200", :sheet=>"basa"},
      {:id=>6, :note=>"@task_three", :start=> "2018-07-29 17:00:00 +0200", :end=> "2018-07-29 18:00:00 +0200", :sheet=>"basa"},
      {:id=>6, :note=>"https://trello.com/c/5X5yXeAK/1-maintenance", :start=> "2018-07-30 17:00:00 +0200", :end=> "2018-07-30 18:00:00 +0200", :sheet=>"basa"},
    ].map do |entry|
      double(
        "Timetrap::Entry",
        values: {
          id: entry[:id],
          note: entry[:note],
          start: DateTime.strptime(entry[:start], date_format),
          end: DateTime.strptime(entry[:end], date_format),
          sheet: entry[:sheet]
        })
    end
  end

  let :tasks do
    [
      {
        "id" => "tr:4",
        "name" => "Maintenance",
        "type" => "task",
        "status" => "open",
        "url" => "https://trello.com/c/5X5yXeAK/1-maintenance",
        "iteration" => "Generic cards",
        "projects" => [
          "tr:fw32Qvi3"
        ],
        "number" => "1",
        "createdAt" => "2018-07-31 14:47:31",
        "labels" => []
      },
      {
        "id" => "tr:5",
        "name" => "Onboarding setup",
        "type" => "task",
        "status" => "open",
        "url" => "https://trello.com/c/nkZSzHcq/3-onboarding-setup",
        "iteration" => "Generic cards",
        "projects" => [
          "tr:fw32Qvi3"
        ],
        "number" => "3",
        "createdAt" => "2018-07-31 14:47:31",
        "labels" => []
      },
      {
        "id" => "tr:6",
        "name" => "Code review",
        "type" => "task",
        "status" => "open",
        "url" => "https://trello.com/c/xItXrptC/2-code-review",
        "iteration" => "Generic cards",
        "projects" => [
          "tr:fw32Qvi3"
        ],
        "number" => "2",
        "createdAt" => "2018-07-31 14:47:31",
        "labels" => []
      }
    ]
  end

  let :alias_map do
    {
      '@task_one': 'tr:1',
      '@task_two': 'tr:2',
      '@task_three': 'tr:3'
    }
  end

  let :parser do
    TimetrapEverhour::EntriesParser.new(
      entries: entries,
      alias_map: alias_map,
      tasks: tasks
    )
  end

  let :expected_result do
    [{:task_id=>"tr:1", :seconds=>12600, :date=>"2018-07-23"},
     {:task_id=>"tr:1", :seconds=>3600, :date=>"2018-07-24"},
     {:task_id=>"tr:2", :seconds=>3600, :date=>"2018-07-25"},
     {:task_id=>"tr:2", :seconds=>3600, :date=>"2018-07-27"},
     {:task_id=>"tr:2", :seconds=>3600, :date=>"2018-07-28"},
     {:task_id=>"tr:3", :seconds=>3600, :date=>"2018-07-29"},
     {:task_id=>"tr:4", :seconds=>3600, :date=>"2018-07-30"}]
  end

  describe "#payloads" do
    subject do
      parser.payloads
    end

    it { is_expected.to eq(expected_result) }
  end
end

