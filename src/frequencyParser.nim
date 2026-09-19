import std/tables

type Frequency = enum
  Hourly
  Daily
  Weekly
  Monthly

type Day = enum
  Monday
  Tuesday
  Wednesday
  Thursday
  Friday
  Saturday
  Sunday

var FrequencyLookup: Table[string, Day] = {"hourly": Hourly}.toTable
