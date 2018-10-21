
public class Parser.LRC : Object {
    private Lyrics.Lyric lyric;

    public Lyrics.Lyric parse (File file) {
        lyric = new Lyrics.Lyric ();
        try {
            DataInputStream dis = new DataInputStream (file.read ());
            string ln;
            while ((ln = dis.read_line ()) != null) {
                parse_line (ln.strip ());
            }
        } catch (Error e) {
            warning (e.message);
        }
        return lyric;
    }

    public Lyrics.Lyric parse_string (string lrc) {
        lyric = new Lyrics.Lyric ();

        foreach (var ln in lrc.split ("\n")) {
            parse_line (ln.strip ());
        }

        return lyric;
    }

    private void parse_line (string ln) {
        var is_lyric = Regex.match_simple ("\\[\\d\\d:\\d\\d\\.\\d\\d\\]", ln);
        var is_metadata = Regex.match_simple ("\\[.+\\]", ln) && !is_lyric;

        if (is_lyric) {
            parse_lyric (ln);
        } else if (is_metadata) {
            parse_metadata (ln);
        }
    }

    private void parse_metadata (string ln) {
        if (ln.has_prefix ("[") && ln.has_suffix ("]")) {
            var md = ln[1:-1];
            var tag = md.split (":", 2);
            lyric.add_metadata (tag[0], tag[1]);
        } else {
            warning ("bad formatted lrc");
        }
    }

    private void parse_lyric (string ln) {
        int minutes, seconds, milli;
        minutes = int.parse (ln[1:3]);
        seconds = int.parse (ln[4:6]);
        milli = int.parse(ln[7:9]);

        if (ln.length > 10) {
            var text = ln[10:ln.length];
            if (text.length > 0) {
                lyric.add_line (time_to_us (minutes, seconds, milli), text);
            }
        }
    }

    // return time in microseconds(µs)
    uint64 time_to_us (uint minutes, uint seconds, uint milliseconds) {
        return (minutes*60*1000 + seconds*1000 + milliseconds)*1000;
    }
}
