
meetings = [{ name: "Meeting 1", duration: 3, type: :onsite}, 
            { name: "Meeting 2", duration: 2, type: :offsite}, 
            { name: "Meeting 3", duration: 1, type: :offsite}, 
            { name: "Meeting 4", duration: 0.5, type: :onsite}
            ]

# visual aid for input of meetings, grouping by :onsite and :offsite in that order
def sort_schedules(meetings)
  meetings.sort_by { |meeting| [meeting[:type], meeting[:duration]] }.reverse
end

def evaluate_schedules(meetings)
  full_day = 8
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

  total_time > full_day  # implicit return on the final check
end

# run program 
sort_schedules(meetings)

=begin 
Your product owner is asking you to implement a new feature in the calendar system that is in your scheduling tool. 
The feature needs to support arranging a set of meetings within an 8 hour day in a way that makes them work, and let the
 user know if the meetings cannot fit into the day.

For this feature there will be two kinds of meetings, on-site meetings and off-site meetings. On-site meetings can be 
scheduled back to back with no gaps in between them, but off-site meetings must have 30 minutes of travel time padded 
to either end. This travel time however can overlap for back to back off-site meetings, and can extend past the start 
and end of the day.

Given a set of meetings (below is an example of a set of meetings):
{
{ name: “Meeting 1”, duration: 3, type: :onsite },
{ name: “Meeting 2”, duration: 2, type: :offsite }, { name: “Meeting 3”, duration: 1, type: :offsite },
{ name: “Meeting 4”, duration: 0.5, type: :onsite }
}
You must write code to determine if these meetings can fit into a 9 to 5 schedule, and propose a layout for those meetings in a format like this:
9:00 - 12:00 - Meeting 1 12:00 - 12:30 - Meeting 4 1:00 - 3:00 - Meeting 2 3:30 - 4:30 - Meeting 3

Note: all proposed solutions do group :onsite and :offsite together, respectively, which is approach I was taking.

inputs: array of hashes, each one representing a meeting
outputs: response as to whether the meetings can all be scheduled
data structures: array, and hashes
presumptions: smallest meeting increments are 30 mins, meaning no 15 minute meetings, etc (potential feature)
alorithm:
- sort though them by :type (not necessary but helps organize my thoughts / visualize)
- if any :offite meetings,
    place all :offsite meetings at beginning of day, eliminating any needed pre-workday buffer(no 30 mins, so start 9am) - no code needed, our sort does this already
    for any successive :offsite meetings, place a 30 min gap between the previous :offsite and the next
    add the :duration cumulatively
    after iterating through the :offsite meetings, add 30 minutes if 8 hours is not taken up
- if any :onsite meetings,
    add 30 minutes to get back home
    for each successive :onsite, add 30 minute overlap and then the next meeting to the cumulative count - no buffer needed at end of day
- return the cumulative amount if the meetings work or not
=end
