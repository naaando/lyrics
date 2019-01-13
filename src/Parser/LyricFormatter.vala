public class Parser.LyricFormatter : Object {
    const string SIMPLIFIED_LYRIC_PATTERN = "(\\[\\d\\d:\\d\\d\\])";
    const string LYRIC_PATTERN = "(\\[\\d\\d:\\d\\d\\.\\d\\d\\])";

    public bool is_timestamp (string ln) {
        return is_simplified_lrc (ln) || is_lrc (ln);
    }

    public bool is_simplified_lrc (string ln) {
        return Regex.match_simple (SIMPLIFIED_LYRIC_PATTERN, ln);
    }

    public bool is_lrc (string ln) {
        return Regex.match_simple (LYRIC_PATTERN, ln);
    }

    public string remove_word_timing (string text) {
        try {
            var regex = new GLib.Regex ("\\<\\d\\d:\\d\\d.\\d\\d\\>");
            return regex.replace (text, -1, 0, "");
        } catch (Error e) {
            warning (e.message);
        }

        return text;
    }

    public string[] split (string ln) {
        if (split_simple_lrc (ln).length > 1) {
            return split_simple_lrc (ln);
        }

        return split_lrc (ln);
    }

    public string[] split_simple_lrc (string ln) {
        return remove_empty (Regex.split_simple (SIMPLIFIED_LYRIC_PATTERN, ln));
    }

    public string[] split_lrc (string ln) {
        return remove_empty (Regex.split_simple (LYRIC_PATTERN, ln));
    }

    public string[] remove_empty (string[] lns) {
        string[] clean_lns = {};
        foreach (var item in lns) {
            if (item != "") {
                clean_lns += item;
            }
        }

        return clean_lns;
    }
}
