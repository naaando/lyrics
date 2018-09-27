
public class Lyrics.StackController : Object {
    Service.PlayerStateService pss;

    public StackController (Service.PlayerStateService player_state_service) {
        pss = player_state_service;
    }

    public Gtk.Stack get_stack () {
        var display = new Display ();
        var download = new Download ();
        var cancellable = new Cancellable ();
        var stack = factory_gtk_stack (display, download);

        pss.state_changed.connect ((player, state) => {
            if (state.to_string () == "PLAYING") {
                var lrc = new Parser.LRC ().parse (GLib.File.new_for_path ("build/lyric.lrc"));
                display.start (lrc, cancellable);
                stack.visible_child_name = state.to_string ();
            } else {
                cancellable.cancel ();
                stack.visible_child_name = state.to_string ();
            }
        });

        return stack;
    }

    private Gtk.Stack factory_gtk_stack (Display display, Download download) {
        var stack = new Gtk.Stack ();
        stack.transition_type = Gtk.StackTransitionType.CROSSFADE;
        stack.border_width = 24;
        stack.margin = 6;
        stack.expand = true;

        stack.add_named (build_no_player (), "NO_PLAYER");
        stack.add_named (build_not_playing (), "NOT_PLAYING");
        stack.add_named (display, "PLAYING");
        stack.add_named (download, "DOWNLOADING");
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
}
