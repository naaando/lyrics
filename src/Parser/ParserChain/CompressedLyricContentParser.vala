public class Parser.CompressedLyricContentParser : ChainOfResponsability {
    LyricFormatter lyric_formatter = new LyricFormatter ();

    public override bool can_parse (string item) {
        return is_compressed (item);
    }

    public override void process (Lyrics.Lyric lyric, string ln) {
        var lns = lyric_formatter.split (ln);

        var last_line = lns.length - 1;
        for (int len = 0; len < last_line; len++) {
            root.parse (lyric, lns[len] + lns[last_line]);
        }
    }

    private bool is_compressed (string ln) {
        return lyric_formatter.split_simple_lrc (ln).length > 2 || lyric_formatter.split_lrc (ln).length > 2;
    }
}
