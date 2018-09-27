
public class Lyrics.Display : Gtk.Box {
    const uint64 one_second_to_nanoseconds = 1000000;
    const int one_second_to_milliseconds = 1000;
    uint64 elapsed_time = 0;

    private Lyric lrc;
    private Gtk.Label current_line;
    Gee.BidirMapIterator<uint64?, string> lrc_iterator;

    public Display () {
        set_size_request (450, 250);

        current_line = new Gtk.Label (null);
        current_line.valign = Gtk.Align.CENTER;
        current_line.expand = true;
        current_line.get_style_context ().add_class ("yellow-lyrics");

        add (current_line);
        //  start (new Parser.LRC ().parse (GLib.File.new_for_path ("build/lyric.lrc")), new Cancellable ());
    }

    public void start (Lyric lrc, uint64 position, Cancellable cancellable) {
        lrc_iterator = lrc.lines.bidir_map_iterator ();
        lrc_iterator.first ();
        elapsed_time = position;

        Timeout.add (one_second_to_milliseconds, () => {
            if (cancellable.is_cancelled ()) {
                cancellable.reset ();
                return false;
            }

            elapsed_time += one_second_to_nanoseconds;
            current_line.label = get_current_line (elapsed_time);
            return true;
        });
    }

    string get_current_line (uint64? elapsed_time) {
        while (lrc_iterator.get_key () < elapsed_time) {
            if (!lrc_iterator.has_next ()) {
                return "";
            }

            lrc_iterator.next ();
        }

        return lrc_iterator.get_value ().to_string ();
    }
}