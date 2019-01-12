
public class Lyrics.ScrolledDisplay : Gtk.ScrolledWindow, IDisplay {
    public string current_line { get; set; }
    public LyricsService lyrics_service { get; set; }

    int64 time;
    Gtk.Box box;
    Gtk.Adjustment adjustment;
    Lyric lyric;
    Gee.HashMap<string, Gtk.Label> labels;
    Cancellable cancellable;

    public ScrolledDisplay () {
        adjustment = vadjustment;
        vscrollbar_policy = Gtk.PolicyType.EXTERNAL;
        set_size_request (450, 250);

        lyrics_service = new LyricsService ();

        box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        box.margin_bottom = 20;
        box.expand = true;
        box.valign = Gtk.Align.END;
        add (box);
    }

    public void on_player_change (Player player) {
        debug (@"Player changed");
        return_if_fail (player.state.to_string () == "PLAYING");

        lyric = lyrics_service.get_lyric (player.current_song);
        return_if_fail (lyric != null);

        on_lyric_change ();
        start (player.position);
    }

    public void on_lyric_change () {
        debug (@"Lyric changed - Displaying $lyric");

        labels = new Gee.HashMap<string, Gtk.Label> ();
        box.forall ((widget) => box.remove (widget));

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
        if (cancellable != null) cancellable.cancel ();
        cancellable = new Cancellable ();

        //  Start transition
        transition_to (labels[lyric.get_next_lyric_timestamp (start_time + (get_monotonic_time () - time)).to_string ()]);

        Timeout.add (250, () => {
            var elapsed = get_monotonic_time () - time;
            var label = labels[lyric.get_next_lyric_timestamp (start_time + elapsed).to_string ()];
            transition_to (label);

            return !cancellable.is_cancelled ();
        });
    }

    void transition_to (Gtk.Label next) {
        labels.foreach ((entry) => {
            entry.value.get_style_context ().remove_class ("selected");
            return true;
        });
        Gtk.Allocation allocation;
        next.get_allocation (out allocation);
        adjustment.value = allocation.y + allocation.height/2 - get_allocated_height ()/2;
        next.get_style_context ().add_class ("selected");
    }

    public void stop () {
        debug ("Stopping display");
    }

    public void clear () {
        foreach (var widget in box.get_children ()) {
            box.remove (widget);
        }
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
}
