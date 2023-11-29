
public class Lyrics.Application : Gtk.Application {
    public static string DEFAULT_LYRICS_DIR = Environment.get_home_dir ()+"/.lyrics/";
    public static GLib.Settings settings = new Settings ("com.github.naaando.lyrics");
    public LyricsService lyrics_service { get; set; }

    private Players players;
    private IDisplay display_view;
    private MainStack main_stack;

    public Application () {
        Object (application_id: "com.github.naaando.lyrics",
        flags: ApplicationFlags.FLAGS_NONE);
        if (settings.get_string ("download-location") == "") {
            settings.set_string ("download-location", DEFAULT_LYRICS_DIR);
        }

        if (!validate_or_create_local_storage ()) {
            warning (@"Unable to save to $DEFAULT_LYRICS_DIR, verify your directory or choose another");
        }

        setup_services ();
    }

    protected override void activate () {
        if (get_windows ().length () > 0) {
            get_windows ().data.present ();
            return;
        }

        display_view = ViewFactory.create_display_view (lyrics_service);
        main_stack = new MainStack (display_view);
        players.on_active_player_changed.connect (() => main_stack.set_player (players.active_player));
        players.on_active_player_changed.connect (() => display_view.set_player (players.active_player));

        var main_window = new MainWindow (this, players, main_stack);
        var header_bar = new Lyrics.HeaderBar (players, lyrics_service);
        main_window.state_flags_changed.connect (() => {
            header_bar.parent_window_is_active = !(Gtk.StateFlags.BACKDROP in main_window.get_state_flags ());
        });
        main_window.set_titlebar (header_bar);
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

    private void setup_services () {
        var syncedLyrics = new SyncedLyrics.Shim();
        syncedLyrics.install();

        lyrics_service = new LyricsService ();
        players = new Players ();
    }

    private bool validate_or_create_local_storage () {
        var local_storage_directory = File.new_for_path (DEFAULT_LYRICS_DIR);

        //  Check if it exist and tries to create directory if not
        try {
            return local_storage_directory.query_exists () || local_storage_directory.make_directory_with_parents ();
        } catch (Error e) {
            warning (e.message);
            return false;
        }
    }
}
