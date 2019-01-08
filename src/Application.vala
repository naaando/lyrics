
public class Lyrics.Application : Gtk.Application {
    public static string DEFAULT_LYRICS_DIR = Environment.get_home_dir ()+"/.lyrics/";
    public static GLib.Settings settings = new Settings ("com.github.naaando.lyrics");

    public Application () {
        Object (application_id: "com.github.naaando.lyrics",
        flags: ApplicationFlags.FLAGS_NONE);
        if (settings.get_string ("download-location") == "") {
            settings.set_string ("download-location", DEFAULT_LYRICS_DIR);
        }
    }

    protected override void activate () {
        if (get_windows ().length () > 0) {
            get_windows ().data.present ();
            return;
        }

        var players = new Players ();

        var scanner = new Mpris.Service ();
        scanner.found.connect ((player) => players.add (player));
        scanner.lost.connect (players.remove_by_busname);
        scanner.setup_dbus ();

        var main_window = new MainWindow (this, players, new MainStack (players));

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
