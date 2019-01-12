public class Lyrics.FileChooserButton : Gtk.FileChooserButton {
    string? _filename;
    public string filename {
        get {
            return _filename;
        }
        set {
            if (value == null) {
                return;
            }

            _filename = value;
            set_filename (_filename);
        }
    }

    public FileChooserButton (string _title, Gtk.FileChooserAction _action) {
        title = _title;
        action = _action;

        selection_changed.connect (() => {
            if (filename != get_filename()) {
                filename = get_filename();
            }
        });
    }
}
