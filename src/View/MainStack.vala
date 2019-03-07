public class Lyrics.MainStack : Gtk.Stack {
    Gtk.Widget no_player_view;
    Gtk.Widget not_playing_view;
    Gtk.Widget no_lyrics_view;
    IDisplay display_view;
    Gtk.Widget downloading_view;

    public MainStack (IDisplay display) {
        transition_type = Gtk.StackTransitionType.CROSSFADE;
        margin = 12;
        margin_top = 0;
        expand = true;

        get_style_context ().add_class ("stack");

        no_player_view = ViewFactory.create_no_player_view ();
        not_playing_view = ViewFactory.create_not_playing_view ();
        no_lyrics_view = ViewFactory.create_no_lyrics_view ();
        display_view = display;
        downloading_view = ViewFactory.create_downloading_view ();

        add_named (no_player_view, "NO_PLAYER");
        add_named (not_playing_view, "STOPPED");

        //  Playing states
        add_named (display_view, "DISPLAYING");
        add_named (downloading_view, "DOWNLOADING");
        add_named (no_lyrics_view, "NO_LYRICS");

        display_view.lyrics_service.notify["state"].connect (on_lyric_service_change);
    }

    public void on_player_change (Player? player) {
        debug (@"Player has changed, player : $(player.busname), state: $(player.state)");

        if (player == null) {
            visible_child_name = "NO_PLAYER";
        } else if (player.state.to_string () != "PLAYING") {
            visible_child_name = "STOPPED";
        } else {
            visible_child_name = "DISPLAYING";
        }
    }

    public void on_lyric_service_change () {
        var state = display_view.lyrics_service.state;

        if (state == Lyrics.LyricsService.DOWNLOADING) { visible_child_name = "DOWNLOADING"; }
        if (state == Lyrics.LyricsService.LYRICS_NOT_FOUND) { visible_child_name = "NO_LYRICS"; }
        if (state == Lyrics.LyricsService.DOWNLOADED) { visible_child_name = "DISPLAYING"; }
    }
}
