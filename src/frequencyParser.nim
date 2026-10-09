import std/tables
import std/options
import std/strutils
import std/strformat

type Frequency* = enum
  Hourly
  Daily
  Weekly
  Monthly

type Day* = enum
  Monday
  Tuesday
  Wednesday
  Thursday
  Friday
  Saturday
  Sunday

const FrequencyLookup: Table[string, Frequency] =
  {"hourly": Hourly, "daily": Daily, "weekly": Weekly, "monthly": Monthly}.toTable

const DayLookup: Table[string, Day] = {
  "MON": Monday,
  "TUE": Tuesday,
  "WED": Wednesday,
  "THU": Thursday,
  "FRI": Friday,
  "SAT": Saturday,
  "SUN": Sunday,
}.toTable

type
  Repetition* = ref RepetitionObj
  RepetitionObj = object
    case frequency*: Frequency
    of Hourly:
      discard
    of Daily:
      atHourD*: Option[int]
    of Weekly:
      onDay*: Option[Day]
      atHourW*: Option[int]
    of Monthly:
      theDate*: Option[int]
      atHourM*: Option[int]

proc parseHourly(words: seq[string]): Repetition =
  return Repetition(frequency: Hourly)

proc parseDaily(words: seq[string]): Repetition =
  var atHour: Option[int] = none(int)

  if words.len >= 3 and words[1] == "at":
    atHour = parseInt(words[2]).some

  return Repetition(frequency: Daily, atHourD: atHour)

proc parseWeekly(words: seq[string]): Repetition =
  var
    onDay: Option[Day] = none(Day)
    atHour: Option[int] = none(int)

  if words.len >= 3 and words[1] == "on" and DayLookup.hasKey(words[2]):
    onDay = DayLookup[words[2]].some

    if words.len >= 5 and words[3] == "at":
      atHour = parseInt(words[4]).some

  return Repetition(frequency: Weekly, onDay: onDay, atHourW: atHour)

proc parseMonthly(words: seq[string]): Repetition =
  var
    theDate: Option[int] = none(int)
    atHour: Option[int] = none(int)

  if words.len >= 3 and words[1] == "the":
    theDate = parseInt(words[2]).some

    if words.len >= 5 and words[3] == "at":
      atHour = parseInt(words[4]).some

  return Repetition(frequency: Monthly, theDate: theDate, atHourM: atHour)

proc parseFrequency*(freq: string): Repetition =
  var words = freq.split()

  if words.len == 0:
    raise newException(Exception, "Cannot parse an empty frequency !")

  if not FrequencyLookup.hasKey(words[0]):
    raise newException(Exception, "Unknown frequency type: " & words[0])

  case FrequencyLookup[words[0]]
  of Hourly:
    return parseHourly(words)
  of Daily:
    return parseDaily(words)
  of Weekly:
    return parseWeekly(words)
  of Monthly:
    return parseMonthly(words)

proc printRepetition*(rep: Repetition): void =
  case rep.frequency
  of Hourly:
    echo "hourly"
  of Daily:
    echo fmt"daily at {rep.atHourD}"
  of Weekly:
    echo fmt"weekly on {rep.onDay} at {rep.atHourW}"
  of Monthly:
    echo fmt"monthly the {rep.theDate} at {rep.atHourM}"
