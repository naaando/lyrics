
public class Lyrics.Lyric : Object {
    private Gee.HashMap<string, string> metadata = new Gee.HashMap<string, string> ();
    private Gee.BidirMapIterator<int64?, string> lrc_iterator;
    private Gee.TreeMap<int64?, string> treemap;

    int offset = 0;

    public int size {
        get {
            return treemap.size;
        }
    }

    public Lyric () {
        GLib.CompareDataFunc<int64?> compare_fn = ((a, b) => {
            if (a - b == 0) return 0;
            return (a - b > 0) ? 1 : -1;
        });

        treemap = new Gee.TreeMap<int64?, string> (compare_fn, Gee.Functions.get_equal_func_for (GLib.Type.STRING));
    }

    public void add_metadata (string _tag, string _info) {
        metadata[_tag] = _info;

        if (_tag == "offset") {
            offset = int.parse (_info);
            message (@"Lyric offset: $offset");
        }
    }

    public string get_metadata (string _tag) {
        return metadata[_tag];
    }

    public void add_line (int64 time, string text) {
        treemap.set (time, text);
    }

    private Gee.BidirMapIterator<int64?, string> get_iterator () throws Error {
        if (treemap.is_empty) {
            Quark q = Quark.from_string ("my-test-str-1");
            throw new Error (q, 1, @"Lyric is empty");
        }

        if (lrc_iterator == null || !lrc_iterator.valid) {
            lrc_iterator = treemap.bidir_map_iterator ();
            lrc_iterator.first ();
        }

        return lrc_iterator;
    }

    public string? get_current_line (int64 time_in_us) {
        var time_with_offset = time_in_us + offset;

        try {
            var iterator = iterator_find_next_timestamp (time_with_offset);
            return iterator.get_value ().to_string ();
        } catch (Error e) {
            return null;
        }
    }

    public int64? get_next_lyric_timestamp (int64 time_in_us) {
        var time_with_offset = time_in_us + offset;

        try {
            var iterator = iterator_find_next_timestamp (time_with_offset);
            return iterator.get_key ();
        } catch (Error e) {
            return null;
        }
    }

    private Gee.BidirMapIterator<int64?, string> iterator_find_next_timestamp (int64 time_in_us) throws Error {
        var iterator = get_iterator ();

        if (iterator.get_key () > time_in_us) {
            iterator.first ();
        }

        while (iterator.get_key () < time_in_us && iterator.has_next ()) {
            iterator.next ();
        }

        if (iterator.has_previous ()) iterator.previous ();

        return iterator;
    }

    public void @foreach (Gee.ForallFunc<Gee.Map.Entry<int64?,string>> func) {
        treemap.foreach (func);
    }

    public string to_string () {
        var builder = new StringBuilder ();

        builder.append (@"Metadata:\n");
        foreach (var data in metadata) {
            builder.append (@"$(data.key) = ");
            builder.append (@"$(data.value)\n");
        }

        builder.append (@"Lyric:\n");
        treemap.foreach ((item) => {
            builder.append (@"$(item.key) : $(item.value)\n");
            return true;
        });

        return builder.str;
    }
}
