
public class Lyrics.Display : Gtk.Box {
    public string current_line {
        get {
            return current_label.label;
        }
        set {
            current_label.label = value;
        }
    }

    Gtk.Label current_label;

    public Display () {
        set_size_request (450, 250);

        current_label = new Gtk.Label (null);
        current_label.wrap = true;
        current_label.justify = Gtk.Justification.CENTER;
        current_label.valign = Gtk.Align.CENTER;
        current_label.expand = true;
        current_label.get_style_context ().add_class ("yellow-lyrics");

        add (current_label);
    }
}
