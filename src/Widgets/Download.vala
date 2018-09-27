
public class Lyrics.Download : Gtk.Grid {
    private Gtk.Label artist;
    private Gtk.Label title;
    private Gtk.Image? cover;

    public Download () {
        cover = new Gtk.Image ();
        cover.valign = Gtk.Align.CENTER;
        cover.halign = Gtk.Align.START;

        title = new Gtk.Label (null);
        title.halign = Gtk.Align.START;
        title.wrap = true;
        title.get_style_context ().add_class ("lyric-title");

        artist = new Gtk.Label (null);
        artist.halign = Gtk.Align.START;
        artist.wrap = true;
        artist.get_style_context ().add_class ("lyric-artist");

        var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        box.add (title);
        box.add (artist);
        box.expand = true;

        valign = Gtk.Align.CENTER;
        expand = true;
        column_spacing = 10;

        attach (cover, 0, 0, 1, 2);
        attach (box, 1, 0);
        attach (new Gtk.Label ("Downloading"), 1, 1);
    }

    public void update (Player player) {
        artist.label = "by "+(player.current_song.artist ?? "Unknown artist");
        title.label = player.current_song.title ?? "Unknown title";
        try {
            cover.set_from_pixbuf (new Gdk.Pixbuf.from_file_at_scale (player.current_song.thumb, 230, 230, true));
        } catch (Error e) {
            message (e.message);
        }
    }
}