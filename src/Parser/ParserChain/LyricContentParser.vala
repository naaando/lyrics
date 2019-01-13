public class Parser.LyricContentParser : ChainOfResponsability {
    LyricFormatter lyric_formatter = new LyricFormatter ();

    public override bool can_parse (string item) {
        return lyric_formatter.is_simplified_lrc (item) || lyric_formatter.is_lrc (item);
    }

    public override void process (Lyrics.Lyric lyric, string ln) {
        var lns = lyric_formatter.split (ln);

        int minutes, seconds, milli;
        parse_time (lns[0], out minutes, out seconds, out milli);
        debug (@"Parsed time: $minutes:$seconds.$milli");

        if (lns[1] == null) return;

        var text = lyric_formatter.remove_word_timing (lns[1]);
        if (text.length > 0) {
            lyric.add_line (time_to_us (minutes, seconds, milli), text);
        }
    }

    void parse_time (string time, out int minutes, out int seconds, out int milli) {
        minutes = int.parse (time [1:3]);
        seconds = int.parse (time [4:6]);
        milli = !(lyric_formatter.is_simplified_lrc (time)) ? int.parse (time [7:9]) : 0;
    }

    // @return time in microseconds(µs)
    int64 time_to_us (uint minutes, uint seconds, uint milliseconds) {
        return (minutes*60*1000 + seconds*1000 + milliseconds)*1000;
    }
}
