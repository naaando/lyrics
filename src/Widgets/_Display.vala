
public class Lyrics.Display : Gtk.DrawingArea {
    private Lyric lrc;
    uint64 y = 0;
    Queue<string> queue = new Queue<string> ();
    uint queue_size = 5;
    Gee.BidirMapIterator<uint64?, string> lrc_iterator;
    Gee.BidirMapIterator<uint64?, string> queue_iterator;

    public Display () {
        set_size_request (450, 250);
        //  lrc = new Parser.LRC ().parse (GLib.File.new_for_path ("build/lyric.lrc"));
    }

    public void start (Lyric lrc, Cancellable cancellable) {
        lrc_iterator = lrc.lines.bidir_map_iterator ();
        queue_iterator = lrc.lines.bidir_map_iterator ();
        lrc_iterator.first ();
        queue_iterator.first ();

        for (int a = 0; a < 1; a++) {
            queue.push_head (queue_iterator.get_value ());
            queue_iterator.next ();
        }

        //  each 1 sec add 1.000.000 nanoseconds(1 second) to y
        Timeout.add (1000, () => {
            if (cancellable.is_cancelled ()) {
                cancellable.reset ();
                return false;
            }

            y+= 1000000;
            //  print (@"$(y/1000000) seconds elapsed\n");
            update ();
            return true;
        });
    }

    void update () {
        if (lrc_iterator.get_key () < y) {
            print (lrc_iterator.get_value ().to_string ()+"\n");
            lrc_iterator.next ();

            if (queue_iterator.next ()) {
                sync_queue ();
            }

            queue_draw ();
        }
    }

    void sync_queue () {
        if (queue.get_length () > queue_size) {
            queue.pop_tail ();
        }
        queue.push_head (queue_iterator.get_value ());
    }

    public void show_lyric (Lyric lyric, uint64 position, Cancellable cancellable = new Cancellable ()) {
        return;
    }

    public override bool draw (Cairo.Context context) {
        int width = get_allocated_width ();
        int height = get_allocated_height ();
        int text_size = 20;
        int spacing = 2;
        int size = text_size + spacing;

        context.set_source_rgb (1, 1, 0.1);
        context.select_font_face ("Arimo", Cairo.FontSlant.NORMAL, Cairo.FontWeight.BOLD);
        context.set_font_size (text_size);

        double h_center = 0;
        Cairo.TextExtents? extents = null;
        for (int a = 0; a < queue_size; a++) {
            print (@"-$a");
            if (queue.peek_nth(a) != null) {
                context.text_extents (queue.peek_nth(a), out extents);
                h_center = (height-extents.height)/2;
                context.move_to ((width-extents.width)/2, h_center+size*(3-a));
                print (@"-$(size*(3-a))\n");
                context.show_text (queue.peek_nth(a));
            }
        }
        print ("\n");

        return false;
    }

    public override bool button_press_event (Gdk.EventButton event) {
        return false;
    }

    public override bool button_release_event (Gdk.EventButton event) {
        return false;
    }

    public override bool motion_notify_event (Gdk.EventMotion event) {
        return false;
    }
}