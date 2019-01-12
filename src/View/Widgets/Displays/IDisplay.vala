public interface Lyrics.IDisplay : Gtk.Widget {
    public abstract LyricsService lyrics_service { get; set; }

    public abstract void on_player_change (Player player);
    public abstract void start (uint64 position);
    public abstract void stop ();
    public abstract void clear ();
}
