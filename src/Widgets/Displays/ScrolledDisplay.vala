
public class Lyrics.ScrolledDisplay : Gtk.ScrolledWindow, IDisplay {
    public string current_line { get; set; }
    Gtk.Box box;
    Gtk.Adjustment adjustment;

    public ScrolledDisplay () {
        adjustment = vadjustment;
        adjustment.changed.connect (() => adjustment.value = adjustment.upper);
        vscrollbar_policy = Gtk.PolicyType.EXTERNAL;
        set_size_request (450, 250);
        box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        box.margin_bottom = 40;
        box.expand = true;
        box.valign = Gtk.Align.END;
        add (box);

        Gtk.Label last_label = null;
        notify["current-line"].connect (() => {
            if (last_label != null && last_label.label == current_line) {
                return;
            }

            if (last_label != null) {
                last_label.get_style_context ().remove_class ("selected");
            }

            last_label = build_lyric_label (current_line);
            last_label.get_style_context ().add_class ("selected");
            box.add (last_label);
        });
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
        lyric_label.get_style_context ().add_class ("yellow-lyrics");
        lyric_label.show_all ();

        return lyric_label;
    }
}
