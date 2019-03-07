
public class Lyrics.ScrolledDisplay : Gtk.ScrolledWindow, IDisplay {
    public string current_line { get; set; }
    public LyricsService lyrics_service { get; set; }

    int64 time;
    Gtk.Box box;
    Gtk.Adjustment adjustment;
    Lyric? lyric;
    Gee.HashMap<string, Gtk.Label> labels;
    Gtk.Label current_label;
    uint current_source_id = 0;

    public ScrolledDisplay (LyricsService lrservice) {
        adjustment = vadjustment;
        vscrollbar_policy = Gtk.PolicyType.EXTERNAL;

        lyrics_service = lrservice;
        lyrics_service.push_lyric.connect (on_lyric_update);

        box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        box.expand = true;
        box.valign = Gtk.Align.END;
        add (box);
    }

    public void on_player_change (Player player) {
        stop ();
        debug (@"Player changed");
        if (player.state.to_string () == "PLAYING") {
            lyrics_service.request_lyric (player.current_song);
            start (player.position);
        }
    }

    public void on_lyric_update (Lyric lyric) {
        this.lyric = lyric;
        return_if_fail (lyric != null);

        debug (@"Lyric changed - Displaying $lyric");

        labels = new Gee.HashMap<string, Gtk.Label> ();

        lyric.foreach ((item) => {
            var label = build_lyric_label (@"$(item.value)");
            labels[item.key.to_string ()] = label;
            box.add (label);
            return true;
        });
    }

    public void start (uint64 position) {
        debug (@"Starting display on position $position");
        time = get_monotonic_time ();
        var start_time = (int64) position;
        remove_source ();

        //  Start transition
        if (lyric != null) {
            transition_to (labels[lyric.get_next_lyric_timestamp (start_time).to_string ()]);
        }

        current_source_id = Timeout.add (250, () => {
            var elapsed = get_monotonic_time () - time;
            if (lyric != null) {
                var label = labels[lyric.get_next_lyric_timestamp (start_time + elapsed).to_string ()];
                transition_to (label);
            }

            return Source.CONTINUE;
        });
    }

    void transition_to (Gtk.Label? next) {
        if (next == current_label) {
            return;
        }

        labels.foreach ((entry) => {
            entry.value.get_style_context ().remove_class ("selected");
            return true;
        });

        return_if_fail (next != null);
        current_label = next;

        Gtk.Allocation allocation;
        current_label.get_allocation (out allocation);
        adjustment.value = allocation.y + allocation.height/2 - get_allocated_height ()/2;
        current_label.get_style_context ().add_class ("selected");
    }

    public void stop () {
        debug ("Stopping display");
        remove_source ();
        clear ();
    }

    public void clear () {
        box.forall ((widget) => box.remove (widget));
    }

    Gtk.Label build_lyric_label (string label) {
        var lyric_label = new Gtk.Label (label);
        lyric_label.wrap = true;
        lyric_label.justify = Gtk.Justification.CENTER;
        lyric_label.valign = Gtk.Align.CENTER;
        lyric_label.get_style_context ().add_class ("display");
        lyric_label.show_all ();

        return lyric_label;
    }

    void remove_source () {
        if (current_source_id > 0) {
            debug (@"Removing source $(current_source_id)");
            Source.remove (current_source_id);
            current_source_id = 0;
        }
    }
}
