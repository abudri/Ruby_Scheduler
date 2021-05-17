# Ruby Scheduler
A small program to determine if a set of schedule inputs can fit in an 8 hour day.

Your product owner is asking you to implement a new feature in the calendar system that is in your scheduling tool. The feature needs to support arranging a set of meetings within an 8 hour day in a way that makes them work, and let the user know if the meetings cannot fit into the day.

For this feature there will be two kinds of meetings, on-site meetings and off-site meetings. On-site meetings can be scheduled back to back with no gaps in between them, but off-site meetings must have 30 minutes of travel time padded to either end. This travel time however can overlap for back to back off-site meetings, and can extend past the start and end of the day.
Given a set of meetings (below is an example of a set of meetings):

```ruby
{
{ name: “Meeting 1”, duration: 3, type: :onsite },
{ name: “Meeting 2”, duration: 2, type: :offsite },
{ name: “Meeting 3”, duration: 1, type: :offsite },
{ name: “Meeting 4”, duration: 0.5, type: :onsite }
}
```

You must write code to determine if these meetings can fit into a 9 to 5 schedule, and propose a layout for those meetings in a format like this:

- 9:00 - 12:00 - Meeting 1
- 12:00 - 12:30 - Meeting 4
- 1:00 - 3:00 - Meeting 2
- 3:30 - 4:30 - Meeting 3

Here are a few example sets for you to test against:

Example 1:

```ruby
{
{ name: “Meeting 1”, duration: 1.5, type: :onsite },
{ name: “Meeting 2”, duration: 2, type: :offsite },
{ name: “Meeting 3”, duration: 1, type: :onsite },
{ name: “Meeting 4”, duration: 1, type: :offsite },
{ name: “Meeting 5”, duration: 1, type: :offsite },
}
```

Yes, can fit. One possible solution would be:

- 9:00 - 10:30 - Meeting 1
- 10:30 - 11:30 - Meeting 3
- 12:00 - 1:00 - Meeting 5
- 1:30 - 2:30 - Meeting 4 3:00 - 5:00 - Meeting 2

Example 2:

```ruby
{
{ name: “Meeting 1”, duration: 4, type: :offsite },
{ name: “Meeting 2”, duration: 4, type: :offsite }
}
```

No, can’t fit.

Example 3:

```ruby
{
{ name: “Meeting 1”, duration: 0.5, type: :offsite },
{ name: “Meeting 2”, duration: 0.5, type: :onsite },
{ name: “Meeting 3”, duration: 2.5, type: :offsite },
{ name: “Meeting 4”, duration: 3, type: :onsite }
}
```

Yes, can fit. One possible solution would be:

- 9:00 - 9:30 - Meeting 2
- 10:00 - 10:30 - Meeting 1
- 11:00 - 2:00 - Meeting 4
- 2:30 - 5:00 - Meeting 3

You must write code to determine if these meetings can fit into a 9 to 5 schedule, and propose a layout for those meetings in a format like this:

____

### PEDAC

PEDAC stands for “[Understand the] Problem, Examples / Test Cases, Data Structure, Algorithm, and Code.” 

Noted that all proposed solutions do group `:onsite` and `:offsite` together, respectively, which is approach I was taking.

**inputs**: array of hashes, each one representing a meeting

**outputs**: response as to whether the meetings can all be scheduled

**data structures**: array, and hashes

**presumptions**: smallest meeting increments are 30 mins, meaning no 15 minute meetings, etc (potential feature)

**alorithm**: Roughly,
- sort though them by `:type`.  This is not necessary but helps organize my thoughts / visualize)
- if any `:onsite` meetings,
  Place all `:onsite` meetings at beginning of day, eliminating any needed pre-workday buffer (no 30 mins, so start 9am). No code needed for this part, our sort does this already.
  Simply add up their cumulative `:duration` times as `:onsite` meetings can be back to back with no gap.
- if any `:offsite` meetings, add `0.5` hours for travel time gap.
- for `:offsite` meetings,
  for any successive `:offsite` meetings, place a 30 min gap between the previous `:offsite` and the next
  add the `:duration` cumulatively
- return the cumulative amount, indicating if the meetings work or not
