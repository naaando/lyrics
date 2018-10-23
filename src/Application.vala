
public class Lyrics.Application : Gtk.Application {
    public static GLib.Settings settings;

    public Application () {
        Object (application_id: "com.github.naaando.lyrics",
        flags: ApplicationFlags.FLAGS_NONE);
    }

    static construct {
        settings = new Settings ("com.github.naaando.lyrics");
    }

    protected override void activate () {
        if (get_windows ().length () > 0) {
            get_windows ().data.present ();
            return;
        }

        var players = new Players ();

        var stack_controller = new Controller.StackController (players);

        var scanner = new Mpris.Service ();
        scanner.found.connect ((player) => players.add (player));
        scanner.lost.connect (players.remove_by_busname);
        scanner.setup_dbus ();

        var main_window = new MainWindow (this, stack_controller.get_stack ());
        main_window.players = players;

        var window_x = settings.get_int ("window-x");
        var window_y = settings.get_int ("window-y");

        if (window_x != -1 ||  window_y != -1) {
            main_window.move (window_x, window_y);
        }

        main_window.show_all ();

        var quit_action = new SimpleAction ("quit", null);

        add_action (quit_action);
        set_accels_for_action ("app.quit", {"Escape"});

        quit_action.activate.connect (() => {
            if (main_window != null) {
                main_window.destroy ();
            }
        });
    }

    private static int main (string[] args) {
        var app = new Application ();
        return app.run (args);
    }
}
