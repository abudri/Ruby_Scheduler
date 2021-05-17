
meetings = [{ name: "Meeting 1", duration: 0.5, type: :offsite}, 
            { name: "Meeting 2", duration: 0.5, type: :onsite}, 
            { name: "Meeting 3", duration: 2.5, type: :onsite}, 
            { name: "Meeting 4", duration: 3, type: :onsite}
            ]

# visual aid for input of meetings, grouping by :onsite and :offsite in that order
def sort_schedules(meetings)
  meetings.sort_by { |meeting| [meeting[:type], meeting[:duration]] }.reverse
end

def evaluate_schedules(meetings)
  full_day = 8.0 # float required to account for 0.5 hour meetings
  total_time = 0 # accumulator for meeting and space between meetings
  offsite_meetings = 0
  onsite_meetings = 0

  # add up meeting times for :onsite
  meetings.select { |meeting| meeting[:duration] if meeting[:type] == :onsite }.each do |hsh|
    total_time += hsh[:duration]
    onsite_meetings += 1
  end
  # if we have onsite meetings, add 0.5 travel time from :onsite to first :offsite
  total_time += 0.5 if meetings.any? { |meeting| meeting.has_value?(:offsite)}
  # add up meeting times for :offsite
  meetings.select { |meeting| meeting[:duration] if meeting[:type] == :offsite }.each do |hsh|
    total_time += hsh[:duration]
    offsite_meetings += 1
    total_time += 0.5 if offsite_meetings > 1
  end

  puts total_time <= full_day  # implicit return on the final check
end

# run program 
evaluate_schedules(meetings)
