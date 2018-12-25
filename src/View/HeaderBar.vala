public class Lyrics.HeaderBar : Gtk.HeaderBar {
    Gtk.Settings settings = Gtk.Settings.get_default ();
    Gtk.Button play_n_pause_btn;
    Players players;

    public HeaderBar (Players players) {
        decoration_layout = "close:menu";
        show_close_button = true;
        get_style_context ().add_class ("titlebar");
        get_style_context ().add_class ("default-decoration");
        players.notify["active-player"].connect (on_active_player_changes);

        var previous_btn = new Gtk.Button.from_icon_name ("media-skip-backward-symbolic");
        previous_btn.clicked.connect (on_previous_btn_clicked);

        play_n_pause_btn = new Gtk.Button.from_icon_name ("media-playback-start-symbolic");
        play_n_pause_btn.clicked.connect (on_play_n_pause_btn_clicked);

        var next_btn = new Gtk.Button.from_icon_name ("media-skip-forward-symbolic");
        next_btn.clicked.connect (on_next_btn_clicked);

        var settings = new Gtk.MenuButton ();
        settings.image = new Gtk.Image.from_icon_name ("open-menu-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
        settings.popover = new SettingsPopover ();

        pack_start (previous_btn);
        pack_start (play_n_pause_btn);
        pack_start (next_btn);

        pack_end (settings);
        pack_end (create_mode_switch ());
    }

    void update_play_n_pause_icon () {
        var icon_name = (players.active_player == null || players.active_player.state != PAUSED) ? "media-playback-start-symbolic" : "media-playback-pause-symbolic";
        if (play_n_pause_btn != null) {
            play_n_pause_btn.image = new Gtk.Image.from_icon_name (icon_name, Gtk.IconSize.SMALL_TOOLBAR);
        }
    }

    void on_active_player_changes () {
        if (players == null | players.active_player == null) {
            return;
        }

        update_play_n_pause_icon ();
        players.active_player.notify.connect (update_play_n_pause_icon);
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
}
