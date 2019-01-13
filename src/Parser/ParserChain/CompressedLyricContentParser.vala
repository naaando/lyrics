public class Parser.CompressedLyricContentParser : ChainOfResponsability {
    LyricFormatter lyric_formatter = new LyricFormatter ();

    public override bool can_parse (string item) {

        return is_compressed (lyric_formatter.split_simple_lrc (item)) || is_compressed (lyric_formatter.split_lrc (item));
    }

    public override void process (Lyrics.Lyric lyric, string ln) {
        var lns = lyric_formatter.split (ln);
        var text_pos = find_text_pos (lns);

        for (int len = 0; len < text_pos; len++) {
            root.parse (lyric, lns[len] + lns[text_pos]);
        }

        if (text_pos > 0 && text_pos < lns.length) {
            root.parse (lyric, string.joinv ("", lns[text_pos:lns.length]));
        }
    }

    int find_text_pos (string[] lns) {
        string text = null;
        int pos = 0;

        while (text == null && pos >= lns.length) {
            if (!lyric_formatter.is_timestamp (lns[pos])) {
                return pos;
            }

            pos++;
        }

        return -1;
    }

    bool is_compressed (string[] lns) {
        int timestamps = 0;
        foreach (var item in lns) {
            if (lyric_formatter.is_timestamp (item)) {
                timestamps++;
            }
        }

        return timestamps > 1;
    }
}
