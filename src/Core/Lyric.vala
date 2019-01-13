
public class Lyrics.Lyric : Gee.TreeMap<int64?, string> {
    private struct Metadata {
        string tag;
        string info;
    }

    private Metadata[] metadata = {};
    Gee.BidirMapIterator<int64?, string> lrc_iterator;
    int offset = 0;

    public Lyric () {
        GLib.CompareDataFunc<int64?> compare_fn = ((a, b) => {
            if (a - b == 0) return 0;
            return (a - b > 0) ? 1 : -1;
        });

        base (compare_fn, Gee.Functions.get_equal_func_for (GLib.Type.STRING));
    }

    public void add_metadata (string _tag, string _info) {
        metadata += Metadata () { tag = _tag, info = _info };
        if (_tag == "offset") {
            offset = int.parse (_info);
            message (@"Lyric offset: $offset");
        }
    }

    public void add_line (int64 time, string text) {
        set (time, text);
    }

    Gee.BidirMapIterator<int64?, string> get_iterator () {
        if (lrc_iterator == null || !lrc_iterator.valid) {
            lrc_iterator = bidir_map_iterator ();

            if (!lrc_iterator.valid) {
                critical ("Can't iterate over null map");
            }

            lrc_iterator.first ();
        }

        return lrc_iterator;
    }

    public string get_current_line (int64 time_in_us) {
        var time_with_offset = time_in_us + offset;
        return iterator_find_next_timestamp (time_with_offset).get_value ().to_string ();
    }

    public int64 get_next_lyric_timestamp (int64 time_in_us) {
        var time_with_offset = time_in_us + offset;
        return iterator_find_next_timestamp (time_with_offset).get_key ();
    }

    Gee.BidirMapIterator<int64?, string> iterator_find_next_timestamp (int64 time_in_us) {
        if (get_iterator ().get_key () > time_in_us) {
            get_iterator ().first ();
        }

        while (get_iterator ().get_key () < time_in_us && get_iterator ().has_next ()) {
            get_iterator ().next ();
        }

        if (get_iterator ().has_previous ()) get_iterator ().previous ();

        return get_iterator ();
    }

    public string to_string () {
        var builder = new StringBuilder ();

        builder.append (@"Metadata:\n");
        foreach (var data in metadata) {
            builder.append (@"$(data.tag) = ");
            builder.append (@"$(data.info)\n");
        }

        builder.append (@"Lyric:\n");
        this.foreach ((item) => {
            builder.append (@"$(item.key) : $(item.value)\n");
            return true;
        });

        return builder.str;
    }
}
