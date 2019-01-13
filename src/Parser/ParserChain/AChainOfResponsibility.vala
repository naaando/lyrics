public abstract class Parser.ChainOfResponsability : Object {
    public ChainOfResponsability? root { get; set; }
    ChainOfResponsability? next_parser;

    public void add_parser_to_chain (ChainOfResponsability parser, ChainOfResponsability? root = null) {
        if (next_parser == null) {
            next_parser = parser;
            next_parser.root = root ?? this;
            return;
        }

        next_parser.add_parser_to_chain (parser);
    }

    public void parse (Lyrics.Lyric lyric, string ln) {
        if (can_parse (ln)) {
            debug (this.get_class ().get_name () + " is able to parse " + ln);
            process (lyric, ln);
        } else if (next_parser != null) {
            next_parser.parse (lyric, ln);
        } else {
            warning (@"Chain ended without being able to parse $ln");
        }
    }

    public abstract bool can_parse (string item);
    public abstract void process (Lyrics.Lyric lyric, string ln);
}
