public class Lyrics.ViewFactory : GLib.Object {
    public static Gtk.Container create_no_player_view () {
        var label = new Gtk.Label (_("Couldn't find any player, check your player's MPRIS configuration"));
        label.wrap = true;
        label.get_style_context ().add_class ("description");

        var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        box.valign = Gtk.Align.CENTER;
        box.add (label);

        return box;
    }

    public static Gtk.Container create_not_playing_view () {
        var label = new Gtk.Label (_("Currently not playing"));
        label.wrap = true;
        label.get_style_context ().add_class ("description");

        var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        box.valign = Gtk.Align.CENTER;
        box.add (label);

        return box;
    }

    public static Gtk.Container create_no_lyrics_view () {
        var label = new Gtk.Label (_("Couldn't find lyrics for song"));
        label.wrap = true;
        label.get_style_context ().add_class ("description");

        var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        box.valign = Gtk.Align.CENTER;
        box.add (label);

        return box;
    }

    public static IDisplay create_display_view () {
        return new ScrolledDisplay ();
    }

    public static Gtk.Container create_downloading_view () {
        return new DownloadView ();
    }
}
