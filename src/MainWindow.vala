
public class Lyrics.MainWindow : Gtk.ApplicationWindow {
    public Players players {
        get {
            return _players;
        }
        set {
            _players = value;
            connect_to_playpause (players);
        }
    }

    Player active_player {
        get {
            return (players == null) ? null : players.active_player;
        }
    }

    Players _players;
    Gtk.Button playpause;

    public MainWindow (Gtk.Application application, Gtk.Stack stack) {
        Object (
            application: application,
            icon_name: "com.github.naaando.lyrics",
            resizable: true,
            title: _("Lyrics"),
            window_position: Gtk.WindowPosition.CENTER
        );

        var context = get_style_context ();
        context.add_class ("rounded");
        context.add_class ("lyrics");

        var provider = new Gtk.CssProvider ();
        provider.load_from_resource ("/com/github/naaando/lyrics/Application.css");
        Gtk.StyleContext.add_provider_for_screen (Gdk.Screen.get_default (), provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);

        set_titlebar (generate_header ());
        set_keep_above (true);
        stick ();

        add (stack);
    }

    Gtk.HeaderBar generate_header () {
        var header = new Gtk.HeaderBar ();
        header.decoration_layout = "close:menu";
        header.show_close_button = true;
        var header_context = header.get_style_context ();
        header_context.add_class ("titlebar");
        header_context.add_class ("default-decoration");

        var mode_switch = new ModeSwitch (
            "display-brightness-symbolic",
            "weather-clear-night-symbolic"
        );
        mode_switch.margin_end = 6;
        mode_switch.primary_icon_tooltip_text = _("Light background");
        mode_switch.secondary_icon_tooltip_text = _("Dark background");
        mode_switch.valign = Gtk.Align.CENTER;

        var gtk_settings = Gtk.Settings.get_default ();
        mode_switch.bind_property ("active", gtk_settings, "gtk_application_prefer_dark_theme");
        mode_switch.notify["active"].connect (() => {
            var context = get_style_context ();
            if (gtk_settings.gtk_application_prefer_dark_theme) {
                context.add_class ("dark");
            } else {
                context.remove_class ("dark");
            }
        });

        Application.settings.bind ("dark", mode_switch, "active", GLib.SettingsBindFlags.DEFAULT);

        /**
         * Left side of headerbar
         */

        /* Player controls */
        //  Previous music button
        header.pack_start (build_button_from_icon ("media-skip-backward-symbolic", null, (btn) => {
            if (active_player != null) {
                active_player.previous ();
            }
        }));

        //  Play/Pause button
        playpause = build_button_from_icon ("media-playback-start-symbolic", null, (btn) => {
            if (active_player != null) {
                active_player.toggle_play_pause ();
            }
        });
        header.pack_start (playpause);

        //  Next music button
        header.pack_start (build_button_from_icon ("media-skip-forward-symbolic", null, (btn) => {
            if (active_player != null) {
                active_player.next ();
            }
        }));


        /**
         * Right side of headerbar
         */

         //  Switch color button
        header.pack_end (mode_switch);
        return header;
    }

    Gtk.Button build_button_from_icon (string icon_name, string? tooltip = null, Func? clicked_cb = null) {
        var button = new Gtk.Button.from_icon_name (icon_name);

        if (tooltip != null) {
            button.tooltip_text = tooltip;
        }

        if (clicked_cb != null) {
            button.clicked.connect (() => clicked_cb (button));
        }

        return button;
    }

    void connect_to_playpause (Players plrs) {
        update_playpause_icon (plrs);

        //  Update play/pause button
        plrs.notify["active-player"].connect (() => {
            if (plrs.active_player == null) {
                return;
            }

            update_playpause_icon (plrs);
            plrs.active_player.notify.connect (() => {
                update_playpause_icon (plrs);
            });
       });
    }

    void update_playpause_icon (Players plrs) {
        var path = (plrs.active_player != null && plrs.active_player.state != PAUSED) ? "media-playback-pause-symbolic" : "media-playback-start-symbolic";
        playpause.image = new Gtk.Image.from_icon_name (path, Gtk.IconSize.SMALL_TOOLBAR);
    }

    public override bool configure_event (Gdk.EventConfigure event) {
        int root_x, root_y;
        get_position (out root_x, out root_y);
        Application.settings.set_int ("window-x", root_x);
        Application.settings.set_int ("window-y", root_y);

        return base.configure_event (event);
    }
}
