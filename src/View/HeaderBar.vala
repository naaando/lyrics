public class Lyrics.HeaderBar : Gtk.HeaderBar {
    public bool parent_window_is_active { get; set; }

    Gtk.Settings settings = Gtk.Settings.get_default ();
    Gtk.Button play_n_pause_btn;
    Players players;
    LyricsService lyrics_service;
    Gtk.Revealer previous_revealer;
    Gtk.Revealer play_n_pause_revealer;
    Gtk.Revealer next_revealer;
    Gtk.Revealer settings_revealer;
    Gtk.Revealer mode_switch_btn_revealer;
    Gtk.Revealer lyrics_search_btn_revealer;
    Gtk.Revealer theme_editor_btn_revealer;

    public HeaderBar (Players _players, LyricsService lrs) {
        decoration_layout = "close:menu";
        show_close_button = true;
        get_style_context ().add_class ("titlebar");
        get_style_context ().add_class ("default-decoration");

        players = _players;
        players.on_active_player_changed.connect (() => update_play_n_pause_icon ());

        lyrics_service = lrs;

        var previous_btn = new Gtk.Button.from_icon_name ("media-skip-backward-symbolic");
        previous_btn.clicked.connect (on_previous_btn_clicked);

        play_n_pause_btn = new Gtk.Button.from_icon_name ("media-playback-start-symbolic");
        play_n_pause_btn.clicked.connect (on_play_n_pause_btn_clicked);

        var next_btn = new Gtk.Button.from_icon_name ("media-skip-forward-symbolic");
        next_btn.clicked.connect (on_next_btn_clicked);

        var settings = new Gtk.MenuButton ();
        settings.image = new Gtk.Image.from_icon_name ("open-menu-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
        settings.popover = new SettingsPopover ();

        previous_revealer = new Gtk.Revealer ();
        previous_revealer.add (previous_btn);
        previous_revealer.transition_type = Gtk.RevealerTransitionType.CROSSFADE;

        play_n_pause_revealer = new Gtk.Revealer ();
        play_n_pause_revealer.add (play_n_pause_btn);
        play_n_pause_revealer.transition_type = Gtk.RevealerTransitionType.CROSSFADE;

        next_revealer = new Gtk.Revealer ();
        next_revealer.add (next_btn);
        next_revealer.transition_type = Gtk.RevealerTransitionType.CROSSFADE;

        settings_revealer = new Gtk.Revealer ();
        settings_revealer.add (settings);
        settings_revealer.transition_type = Gtk.RevealerTransitionType.CROSSFADE;

        mode_switch_btn_revealer = new Gtk.Revealer ();
        mode_switch_btn_revealer.add (create_mode_switch ());
        mode_switch_btn_revealer.transition_type = Gtk.RevealerTransitionType.CROSSFADE;

        lyrics_search_btn_revealer = new Gtk.Revealer ();
        lyrics_search_btn_revealer.add (create_lyrics_search ());
        lyrics_search_btn_revealer.transition_type = Gtk.RevealerTransitionType.CROSSFADE;

        theme_editor_btn_revealer = new Gtk.Revealer ();
        theme_editor_btn_revealer.add (create_theme_editor_btn ());
        theme_editor_btn_revealer.transition_type = Gtk.RevealerTransitionType.CROSSFADE;

        pack_start (previous_revealer);
        pack_start (play_n_pause_revealer);
        pack_start (next_revealer);

        pack_end (settings_revealer);
        pack_end (mode_switch_btn_revealer);
        pack_end (lyrics_search_btn_revealer);
        pack_end (theme_editor_btn_revealer);

        Application.settings.changed["hide-headerbar-widgets-on-backdrop"].connect (configure_widgets_on_backdrop);
        notify["parent-window-is-active"].connect (() => configure_widgets_on_backdrop ());
    }

    void configure_widgets_on_backdrop () {
        var should_hide_widgets = Application.settings.get_boolean ("hide-headerbar-widgets-on-backdrop");

        //  Wrap within timeout to avoid activating a button
        Timeout.add (50, () => {
            if (parent_window_is_active || !should_hide_widgets) {
                previous_revealer.set_reveal_child (true);
                play_n_pause_revealer.set_reveal_child (true);
                next_revealer.set_reveal_child (true);
                settings_revealer.set_reveal_child (true);
                mode_switch_btn_revealer.set_reveal_child (true);
                lyrics_search_btn_revealer.set_reveal_child (true);
                theme_editor_btn_revealer.set_reveal_child (true);
            } else {
                previous_revealer.set_reveal_child (false);
                play_n_pause_revealer.set_reveal_child (false);
                next_revealer.set_reveal_child (false);
                settings_revealer.set_reveal_child (false);
                mode_switch_btn_revealer.set_reveal_child (false);
                lyrics_search_btn_revealer.set_reveal_child (false);
                theme_editor_btn_revealer.set_reveal_child (false);
            }

            return false;
        });
    }

    void update_play_n_pause_icon () {
        bool is_player_paused = players.active_player != null && players.active_player.state == Lyrics.Player.State.PAUSED;
        var icon_name = is_player_paused ? "media-playback-start-symbolic" : "media-playback-pause-symbolic";
        if (play_n_pause_btn != null) {
            play_n_pause_btn.image = new Gtk.Image.from_icon_name (icon_name, Gtk.IconSize.SMALL_TOOLBAR);
        }
    }

    void on_previous_btn_clicked () {
        if (players.active_player != null) {
            players.active_player.previous ();
        }
    }

    void on_play_n_pause_btn_clicked () {
        if (players.active_player != null) {
            players.active_player.toggle_play_pause ();
        }
    }

    void on_next_btn_clicked () {
        if (players.active_player != null) {
            players.active_player.next ();
        }
    }

    Gtk.Widget create_mode_switch () {
        var mode_switch = new ModeSwitch (
            "display-brightness-symbolic",
            "weather-clear-night-symbolic"
        );

        mode_switch.margin_end = 6;
        mode_switch.primary_icon_tooltip_text = _("Light background");
        mode_switch.secondary_icon_tooltip_text = _("Dark background");
        mode_switch.valign = Gtk.Align.CENTER;
        mode_switch.bind_property ("active", settings, "gtk_application_prefer_dark_theme");
        Application.settings.bind ("dark", mode_switch, "active", GLib.SettingsBindFlags.DEFAULT);

        return mode_switch;
    }

    Gtk.Widget create_lyrics_search () {
        var search_btn = new Gtk.Button.from_icon_name ("system-search-symbolic");
        search_btn.margin_end = 6;

        search_btn.clicked.connect (() => {
            var parent_window = get_ancestor (typeof (Gtk.Window));
            return_if_fail (parent_window != null);

            var song = (players.active_player != null) ? players.active_player.current_song : null;
            var search_dialog = new Lyrics.SearchLyricDialog ((Gtk.Window) parent_window, song);
            search_dialog.lyrics_service = lyrics_service;
            search_dialog.show_all ();
        });

        return search_btn;
    }
}
