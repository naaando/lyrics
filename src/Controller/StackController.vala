
public class Lyrics.Controller.StackController : Object {
    Players players;
    Gtk.Stack stack;
    DisplayController display_controller = new DisplayController ();

    public StackController (Players _players) {
        var download = new Download ();
        stack = factory_gtk_stack (display_controller.display, download);

        players = _players;

        //  FIXME: Signal not working outside thread
        new Thread<int> ("players-signals",() => {
            var loop = new MainLoop ();
            players.notify["active-player"].connect (() => {
                if (players.active_player != null) {
                    players.active_player.notify.connect (() => {
                        update_stack ();
                    });
                }
                update_stack ();
            });

            loop.run ();

            return 0;
        });
    }

    public void update_stack () {
        if (players.active_player == null) {
            stack.visible_child_name = "NO_PLAYER";
            return;
        }

        if (players.active_player.state.to_string () == "PLAYING") {
            display_controller.start (players.active_player) ? stack.visible_child_name = players.active_player.state.to_string () : stack.visible_child_name = "NO_LYRICS";
        } else {
            display_controller.stop ();
            stack.visible_child_name = "STOPPED";
        }
    }

    public Gtk.Stack get_stack () {
        return stack;
    }

    private Gtk.Stack factory_gtk_stack (Display display, Download download) {
        var stack = new Gtk.Stack ();
        stack.transition_type = Gtk.StackTransitionType.CROSSFADE;
        stack.border_width = 24;
        stack.margin = 6;
        stack.expand = true;

        var context = stack.get_style_context ();
        context.add_class ("stack");

        stack.add_named (build_no_player (), "NO_PLAYER");
        stack.add_named (build_not_playing (), "STOPPED");
        stack.add_named (display_controller.display, "PLAYING");
        stack.add_named (download, "DOWNLOADING");
        stack.add_named (build_no_lyrics (), "NO_LYRICS");
        return stack;
    }

    private Gtk.Box build_no_player () {
        var label = new Gtk.Label ("Couldn't find any player, check your player's MPRIS configuration");
        label.wrap = true;
        label.get_style_context ().add_class ("description");

        var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        box.valign = Gtk.Align.CENTER;
        box.add (label);

        return box;
    }

    private Gtk.Box build_not_playing () {
        var label = new Gtk.Label ("Currently not playing");
        label.wrap = true;
        label.get_style_context ().add_class ("description");

        var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        box.valign = Gtk.Align.CENTER;
        box.add (label);

        return box;
    }

    private Gtk.Box build_no_lyrics () {
        var label = new Gtk.Label ("Couldn't find lyrics for song");
        label.wrap = true;
        label.get_style_context ().add_class ("description");

        var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        box.valign = Gtk.Align.CENTER;
        box.add (label);

        return box;
    }
}
