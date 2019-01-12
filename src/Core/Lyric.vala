
public class Lyrics.Lyric : Gee.TreeMap<uint64?, string> {
    private struct Metadata {
        string tag;
        string info;
    }

    private Metadata[] metadata = {};
    //   lines = new Gee.TreeMap<uint64?, string> ();
    Gee.BidirMapIterator<uint64?, string> lrc_iterator;
    int offset = 0;

    public void add_metadata (string _tag, string _info) {
        metadata += Metadata () { tag = _tag, info = _info };
        if (_tag == "offset") {
            offset = int.parse (_info);
            message (@"Lyric offset: $offset");
        }
    }

    public void add_line (uint64 time, string text) {
        set (time, text);
    }

    public Gee.TreeMap<uint64?, string> get_lyric () {
        return this;
    }

    Gee.BidirMapIterator<uint64?, string> get_iterator () {
        if (lrc_iterator == null) {
            lrc_iterator = bidir_map_iterator ();
            lrc_iterator.first ();
        }

        return lrc_iterator;
    }

    public string get_current_line (uint64 time_in_us) {
        var time_with_offset = time_in_us + offset;
        return iterator_find_next_timestamp (time_with_offset).get_value ().to_string ();
    }

    public uint64 get_next_lyric_timestamp (uint64 time_in_us) {
        var time_with_offset = time_in_us + offset;
        return iterator_find_next_timestamp (time_with_offset).get_key ();
    }

    Gee.BidirMapIterator<uint64?, string> iterator_find_next_timestamp (uint64 time_in_us) {
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
