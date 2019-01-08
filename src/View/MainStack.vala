public class Lyrics.MainStack : Gtk.Stack {
    public Gtk.Widget no_player_view { get;set; default = MainStack.build_no_player (); }
    public Gtk.Widget not_playing_view { get; set; default = MainStack.build_not_playing (); }
    public Gtk.Widget lyrics_not_found_view { get; set; default = MainStack.build_no_lyrics (); }

    public Gtk.Widget? lyrics_display { get; set; }
    public Gtk.Widget? downloading_view { get; set; }
    Controller.DisplayController display_controller = new Controller.DisplayController ();
    Players players;

    public MainStack (Players _players) {
        transition_type = Gtk.StackTransitionType.CROSSFADE;
        border_width = 24;
        margin = 6;
        expand = true;

        get_style_context ().add_class ("stack");

        lyrics_display = display_controller.display;
        downloading_view = new Download ();

        add_named (no_player_view, "NO_PLAYER");
        add_named (not_playing_view, "STOPPED");
        add_named (lyrics_display, "PLAYING");
        add_named (downloading_view, "DOWNLOADING");
        add_named (lyrics_not_found_view, "NO_LYRICS");

        players = _players;

        players.notify["active-player"].connect (on_active_player_change);
    }

    void on_active_player_change () {
        if (players.active_player != null) {
            players.active_player.notify.connect (() => {
                update_stack ();
            });
        }

        update_stack ();
    }

    public void update_stack () {
        if (players.active_player == null) {
            visible_child_name = "NO_PLAYER";
            return;
        }

        if (players.active_player.state.to_string () == "PLAYING") {
            display_controller.start (players.active_player) ? visible_child_name = players.active_player.state.to_string () : visible_child_name = "NO_LYRICS";
        } else {
            display_controller.stop ();
            visible_child_name = "STOPPED";
        }
    }

    static Gtk.Box build_no_player () {
        var label = new Gtk.Label ("Couldn't find any player, check your player's MPRIS configuration");
        label.wrap = true;
        label.get_style_context ().add_class ("description");

        var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        box.valign = Gtk.Align.CENTER;
        box.add (label);

        return box;
    }

    static Gtk.Box build_not_playing () {
        var label = new Gtk.Label ("Currently not playing");
        label.wrap = true;
        label.get_style_context ().add_class ("description");

        var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        box.valign = Gtk.Align.CENTER;
        box.add (label);

        return box;
    }

    static Gtk.Box build_no_lyrics () {
        var label = new Gtk.Label ("Couldn't find lyrics for song");
        label.wrap = true;
        label.get_style_context ().add_class ("description");

        var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        box.valign = Gtk.Align.CENTER;
        box.add (label);

        return box;
    }
}
