
public class Parser.LRC : Object {
    private Lyrics.Lyric lyric;
    ChainOfResponsability parse_chain;

    public LRC () {
        parse_chain = new LyricEmptyStringParser ();
        parse_chain.add_parser_to_chain (new LyricMetadataParser ());
        parse_chain.add_parser_to_chain (new CompressedLyricContentParser ());
        parse_chain.add_parser_to_chain (new LyricContentParser ());
    }

    public Lyrics.Lyric parse (File file) {
        lyric = new Lyrics.Lyric ();
        try {
            DataInputStream dis = new DataInputStream (file.read ());
            string ln;
            size_t length;

            while ((ln = dis.read_upto ("[", -1, out length)) != null) {
                debug ("Parsing line: " + ln);
                parse_chain.parse (lyric, "[" + ln.strip ());
                dis.read_byte ();
            }
        } catch (Error e) {
            warning (e.message);
        }
        return lyric;
    }

    public Lyrics.Lyric parse_string (string lrc) {
        lyric = new Lyrics.Lyric ();

        foreach (var ln in lrc.split ("\n")) {
            parse_chain.parse (lyric, ln.strip ());
        }

        return lyric;
    }
}
