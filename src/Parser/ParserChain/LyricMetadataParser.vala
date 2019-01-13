public class Parser.LyricMetadataParser : ChainOfResponsability {
    public override bool can_parse (string item) {
        return Regex.match_simple ("\\[\\D", item);
    }

    public override void process (Lyrics.Lyric lyric, string ln) {
        if (ln.has_prefix ("[") && ln.has_suffix ("]")) {
            var md = ln[1:-1];
            var tag = md.split (":", 2);
            lyric.add_metadata (tag[0], tag[1]);
        } else {
            warning (@"Couldn't parse $ln");
        }
    }
}
