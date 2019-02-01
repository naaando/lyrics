public class Lyrics.ViewFactory : GLib.Object {
    public static Gtk.Container create_no_player_view () {
        return create_message_view (_("Couldn't find any player, check your player's MPRIS configuration"));
    }

    public static Gtk.Container create_not_playing_view () {
        return create_message_view (_("Currently not playing"));
    }

    public static Gtk.Container create_no_lyrics_view () {
        return create_message_view (_("Couldn't find lyrics for song"));
    }

    public static IDisplay create_display_view (LyricsService lyrics_service) {
        return new ScrolledDisplay (lyrics_service);
    }

    public static Gtk.Container create_downloading_view () {
        return create_message_view (_("Downloading"));
    }

    public static Gtk.Container create_message_view (string message) {
        var label = new Gtk.Label (message);
        label.wrap = true;
        label.get_style_context ().add_class ("description");

        var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        box.valign = Gtk.Align.CENTER;
        box.add (label);

        return box;
    }
}
