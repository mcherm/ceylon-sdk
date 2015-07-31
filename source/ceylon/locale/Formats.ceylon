import ceylon.time.base {
    ReadableDate,
    ReadableTime,
    sunday
}
import ceylon.time {
    Date,
    date,
    Time,
    time
}

"Date, time, currency, and numeric formats for a certain
 [[Locale]]."
shared sealed class Formats(
    shortDateFormat, 
    mediumDateFormat, 
    longDateFormat, 
    shortTimeFormat, 
    mediumTimeFormat, 
    longTimeFormat, 
    integerFormat, 
    floatFormat, 
    percentageFormat, 
    currencyFormat,
    monthNames,
    monthAbbreviations,
    weekdayNames,
    weekdayAbbreviations,
    ampm) {
    
    shared String shortDateFormat;
    shared String mediumDateFormat;
    shared String longDateFormat;
    
    shared String shortTimeFormat;
    shared String mediumTimeFormat;
    shared String longTimeFormat;
    
    shared String integerFormat;
    shared String floatFormat;
    shared String percentageFormat;
    shared String currencyFormat;
    
    [String,String] ampm;
    shared String am => ampm[0];
    shared String pm => ampm[1]; 
    
    shared String[] weekdayNames;
    shared String[] weekdayAbbreviations;
    shared String[] monthNames;
    shared String[] monthAbbreviations;
    
    shared String shortFormatDate(ReadableDate date) 
            => formatDate(shortDateFormat, date);
    shared String mediumFormatDate(ReadableDate date) 
            => formatDate(mediumDateFormat, date);
    shared String longFormatDate(ReadableDate date) 
            => formatDate(longDateFormat, date);
    
    shared String shortFormatTime(ReadableTime time) 
            => formatTime(shortTimeFormat, time);
    shared String mediumFormatTime(ReadableTime time) 
            => formatTime(mediumTimeFormat, time);
    shared String longFormatTime(ReadableTime time) 
            => formatTime(longTimeFormat, time);
    
    String formatDate(String format, ReadableDate date) {
        function interpolateToken(Integer->String token) 
                => 2.divides(token.key)
                    then formatDateToken(token.item, date) 
                    else token.item;
        value tokens = format.split('\''.equals, true, false);
        return String(tokens.indexed.flatMap(interpolateToken));
    }
    
    String formatTime(String format, ReadableTime time) {
        function interpolateToken(Integer->String token) 
                => 2.divides(token.key) 
                    then formatTimeToken(token.item, time) 
                    else token.item;
        value tokens = format.split('\''.equals, true, false);
        return String(tokens.indexed.flatMap(interpolateToken));
    }
    
    String formatDateToken(String token, ReadableDate date) {
        value weekdayName = 
                weekdayNames[date.dayOfWeek.integer-1] 
                else date.dayOfWeek.string;
        value weekdayAbbr = 
                weekdayAbbreviations[date.dayOfWeek.integer-1] 
                else date.dayOfWeek.string.initial(3);
        value monthName = 
                monthNames[date.month.integer-1] 
                else date.month.string;
        value monthAbbr = 
                monthAbbreviations[date.month.integer-1] 
                else date.month.string.initial(3);
        value month = date.month.integer.string;
        value twoDigitMonth = month.padLeading(2,'0');
        value day = date.day.string;
        value twoDigitDay = day.padLeading(2,'0');
        value fourDigitYear = date.year.string.padLeading(4,'0');
        value twoDigitYear = date.year.string.padLeading(2,'0').terminal(2);
        value weekOfYear = date.weekOfYear.string;
        value twoDigitWeekOfYear = weekOfYear.padLeading(2,'0');
        value dayNumberInWeek = 
                let (dow=date.dayOfWeek) 
                (dow==sunday then 7 else dow.integer).string;
        return token
                .replaceFirst("EEEE", weekdayName)
                .replaceFirst("EEE", weekdayAbbr)
                .replaceFirst("EE", weekdayAbbr)
                .replaceFirst("E", weekdayAbbr)
                .replaceFirst("MMMM", monthName)
                .replaceFirst("MMM", monthAbbr)
                .replaceFirst("MM", twoDigitMonth)
                .replaceFirst("M", month)
                .replaceFirst("dd", twoDigitDay)
                .replaceFirst("d", day)
                .replaceFirst("u", dayNumberInWeek)
                .replaceFirst("yyyy", fourDigitYear)
                .replaceFirst("yyy", fourDigitYear)
                .replaceFirst("yy", twoDigitYear)
                .replaceFirst("y", fourDigitYear) //yes, really
                .replaceFirst("W", "") //TODO: week of month
                .replaceFirst("F", "") //TODO: day of week in month
                .replaceFirst("ww", twoDigitWeekOfYear)
                .replaceFirst("w", weekOfYear)
                .trimmed;
    }
    
    function twelveHour(Integer hour)
              => if (hour==0) then [12,ampm[0]]
            else if (hour<=12) then [hour,ampm[0]]
            else [hour-12,ampm[1]];
    
    String formatTimeToken(String token, ReadableTime time) {
        value hourAndAmpm = twelveHour(time.hours);
        value twelvehour = hourAndAmpm[0].string;
        value weirdTwelvehour = (time.hours<12 then time.hours else time.hours-12).string;
        value twoDigitTwelvehour = hourAndAmpm[0].string.padLeading(2, '0');
        value twoDigitWeirdTwelvehour = weirdTwelvehour.padLeading(2, '0');
        value ampm = hourAndAmpm[1];
        value hour = time.hours.string;
        value twoDigitHour = hour.padLeading(2, '0');
        value weirdHour = (time.hours+1).string;
        value twoDigitWeirdHour = weirdHour.padLeading(2, '0');
        value mins = time.minutes.string;
        value twoDigitMins = mins.padLeading(2, '0');
        value secs = time.seconds.string;
        value twoDigitSecs = secs.padLeading(2, '0');
        value millis = time.milliseconds.string;
        value threeDigitMillis = millis.padLeading(3,'0');
        value twoDigitMillis = millis.padLeading(3,'0');
        return token
                .replaceFirst("hh", twoDigitTwelvehour)
                .replaceFirst("h", twelvehour)
                .replaceFirst("KK", twoDigitWeirdTwelvehour)
                .replaceFirst("K", weirdTwelvehour)
                .replaceFirst("HH", twoDigitHour)
                .replaceFirst("H", hour)
                .replaceFirst("kk", twoDigitWeirdHour)
                .replaceFirst("k", weirdHour)
                .replaceFirst("a", ampm)
                .replaceFirst("mm", twoDigitMins)
                .replaceFirst("m", mins)
                .replaceFirst("ss", twoDigitSecs)
                .replaceFirst("s", secs)
                .replaceFirst("SSS", threeDigitMillis)
                .replaceFirst("SS", twoDigitMillis)
                .replaceFirst("S", millis)
                .replaceFirst("X", "") //TODO TimeZone not yet supported
                .replaceFirst("Z", "") //TODO TimeZone not yet supported
                .replaceFirst("z", "") //TODO TimeZone not yet supported
                .replaceFirst("G", "") //TODO: era
                .trimmed;
    }
    
    "Given a [[string|text]] expected to represent a 
     formatted date, comprising day, month, and year fields, 
     the [[order|dateOrder]] of the fields in the formatted 
     date, and a list of [[delimiting characters|separators]], 
     return a [[Date]], or `null` if the string cannot be 
     interpreted as a date with the given field order and 
     delimiters.
     
     For example
     
         au.formats.parseDate(\"3 June 2010\")
     
     produces the date `2010-6-03`, if `au` is the `Locale`
     for `en-AU`. And
     
         us.formats.parseDate(\"01/02/2000\", monthDayYear)
     
     produces the date `2000-01-02`, if `us` is the `Locale`
     for `en-US`."
    throws (`class AssertionError`, 
            "if the given [[order|dateOrder]] does not 
             include the day, month, and year")
    shared Date? parseDate(
        "The formatted date."
        String text,
        "The order of the fields of the fomatted date,
         usually [[dayMonthYear]], [[yearMonthDay]], or
         [[monthDayYear]]."
        DateField.Order dateOrder
                //TODO: get the default from the locale! 
                = dayMonthYear,
        "The characters to recognize as field separators."
        String separators = "/-., ") {
        
        "field order must include day"
        assert (exists dayIndex = 
                dateOrder.firstOccurrence(DateField.day));
        "field order must include month"
        assert (exists monthIndex = 
                dateOrder.firstOccurrence(DateField.month));
        "field order must include year"
        assert (exists yearIndex = 
                dateOrder.firstOccurrence(DateField.year));
        
        value bits = 
                text.split(separators.contains)
                    .map(String.trimmed)
                    .sequence();
            
        Integer day;
        if (exists dayBit = bits[dayIndex]) {
            if (exists d = parseInteger(dayBit)) {
                day = d;
            }
            else {
                return null;
            }
        }
        else {
            return null;
        }
        
        Integer month;
        if (exists monthBit = bits[monthIndex]) {
            if (exists m = parseInteger(monthBit)) {
                month = m;
            }
            else if (exists m = monthNames.locate(monthBit.equalsIgnoringCase)) {
                month = m.key+1;
            }
            else if (exists m = monthAbbreviations.locate(monthBit.equalsIgnoringCase)) {
                month = m.key+1;
            }
            else {
                return null;
            }
        }
        else {
            return null;
        }
        
        Integer year;
        if (exists yearBit = bits[yearIndex]) {
            if (exists y = parseInteger(yearBit)) {
                year = y;
            }
            else {
                return null;
            }
        }
        else {
            return null;
        }
        
        return date {
            year = year;
            month = month;
            day = day;
        };
    }
    
    "Given a [[string|text]] expected to represent a 
     formatted time, comprising an hour, followed by 
     optional minute, second, and millisecond fields, 
     followed by an optional AM or PM marker, and a list of 
     [[delimiting characters|separators]], return a [[Time]], 
     or `null` if the string cannot be interpreted as a time 
     with the given delimiters."
    shared Time? parseTime(
    "The formatted time."
        String text,
        "The characters to recognize as field separators."
        String separators = ":. ") {
        
        value bitsWithAmPm = 
                text.split(separators.contains)
                    .map(String.trimmed)
                    .sequence();
        
        String[] bits;
        Boolean adjust;
        if (nonempty bitsWithAmPm) {
            value last = bitsWithAmPm.last;
            value eqPm = pm.equalsIgnoringCase(last);
            value eqAm = am.equalsIgnoringCase(last);
            if (eqPm || eqAm) {
                bits = bitsWithAmPm[0:bitsWithAmPm.size-1];
                adjust = eqPm;
            }
            else {
                bits = bitsWithAmPm;
                adjust = false;
            }
        }
        else {
            return null;
        }
        
        Integer hour;
        if (exists hourBit = bits[0]) {
            if (exists d = parseInteger(hourBit)) {
                hour = d;
            }
            else {
                return null;
            }
        }
        else {
            return null;
        }
        
        Integer minute;
        if (exists minuteBit = bits[1]) {
            if (exists m = parseInteger(minuteBit)) {
                minute = m;
            }
            else {
                return null;
            }
        }
        else {
            minute = 0;
        }
        
        Integer second;
        if (exists secondBit = bits[2]) {
            if (exists y = parseInteger(secondBit)) {
                second = y;
            }
            else {
                return null;
            }
        }
        else {
            second = 0;
        }
        
        Integer millis;
        if (exists msBit = bits[3]) {
            if (exists y = parseInteger(msBit)) {
                millis = y;
            }
            else {
                return null;
            }
        }
        else {
            millis = 0;
        }
        
        return time {
            hours = adjust then hour+12 else hour;
            minutes = minute;
            seconds = second;
            milliseconds = millis;
        };
    }

}

Formats parseFormats(Iterator<String> lines) {
    
    assert (!is Finished ampmLine = lines.next());
    value ampmCols = columns(ampmLine).iterator();
    assert (is String am=ampmCols.next(), 
        is String pm=ampmCols.next());
    
    assert (!is Finished monthsNameLine = lines.next());
    value monthNames = columns(monthsNameLine).coalesced.sequence();
    assert (!is Finished monthsAbbrLine = lines.next());
    value monthAbbreviations = columns(monthsAbbrLine).coalesced.sequence();
    
    assert (!is Finished dayNameLine = lines.next());
    value dayNames = columns(dayNameLine).coalesced.sequence();
    assert (!is Finished dayAbbrLine = lines.next());
    value dayAbbreviations = columns(dayAbbrLine).coalesced.sequence();
    
    assert (!is Finished dateFormats = lines.next());
    value dateCols = columns(dateFormats).iterator();
    assert (is String shortDateFormat = dateCols.next());
    assert (is String mediumDateFormat = dateCols.next());
    assert (is String longDateFormat = dateCols.next());
    assert (!is Finished timeFormats = lines.next());
    
    value timeCols = columns(timeFormats).iterator();
    assert (is String shortTimeFormat = timeCols.next());
    assert (is String mediumTimeFormat = timeCols.next());
    assert (is String longTimeFormat = timeCols.next());
    assert (!is Finished numberFormats = lines.next());
    
    value numCols = columns(numberFormats).iterator();
    assert (is String integerFormat = numCols.next());
    assert (is String floatFormat = numCols.next());
    assert (is String percentageFormat = numCols.next());
    assert (is String currencyFormat = numCols.next());
    
    assert (!is Finished blankLine1 = lines.next(), 
            blankLine1.empty);
    
    return Formats {
        shortDateFormat = shortDateFormat;
        mediumDateFormat = mediumDateFormat;
        longDateFormat = longDateFormat;
        shortTimeFormat = shortTimeFormat;
        mediumTimeFormat = mediumTimeFormat;
        longTimeFormat = longTimeFormat;
        integerFormat = integerFormat;
        floatFormat = floatFormat;
        percentageFormat = percentageFormat;
        currencyFormat = currencyFormat;
        ampm = [am,pm];
        monthNames = monthNames;
        monthAbbreviations = monthAbbreviations;
        weekdayNames = dayNames;
        weekdayAbbreviations = dayAbbreviations;
    };
}