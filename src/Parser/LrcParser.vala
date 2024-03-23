
public class Parser.LrcParser : Object {
    private Lyric lyric;
    ChainOfResponsability parse_chain;

    public LrcParser () {
        parse_chain = new LyricEmptyStringParser ();
        parse_chain.add_parser_to_chain (new LyricMetadataParser ());
        parse_chain.add_parser_to_chain (new CompressedLyricContentParser ());
        parse_chain.add_parser_to_chain (new LyricContentParser ());
    }

    public Lyric? parse_file (File file) {
        lyric = new Lyric ();

        try {
            DataInputStream dis = new DataInputStream (file.read ());
            string? line = "";

            do {
                //  Using deprecated method read_until because read_upto is buggy
                line = dis.read_until ("[", null);

                if (line != null && (line = line.strip ()) != "") {
                    parse_string ("[" + line);
                }
            } while (line != null);
        } catch (Error e) {
            warning (e.message);
            lyric = null;
        }

        return lyric;
    }

    private void parse_string (string ln) {
        debug ("Parsing line: " + ln);
        parse_chain.parse (lyric, ln.strip ());
    }
}
