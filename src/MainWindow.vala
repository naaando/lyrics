
public class Lyrics.MainWindow : Gtk.ApplicationWindow {
    public Players players { get; set; }

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

        header.pack_start (build_button_from_icon ("media-skip-backward-symbolic"));
        header.pack_start (build_button_from_icon ("media-playback-start-symbolic"));
        header.pack_start (build_button_from_icon ("media-skip-forward-symbolic"));

        header.pack_end (build_preferences_button ());
        header.pack_end (mode_switch);
        header.pack_end (build_button_from_icon ("image-red-eye-symbolic", _("Toggle transparency when window go inactive")));
        header.pack_end (build_button_from_icon ("document-new-symbolic", _("Edit lyric file")));
        header.pack_end (build_button_from_icon ("edit-find-symbolic", _("Search lyric")));

        return header;
    }

    Gtk.ComboBoxText build_players_combobox () {
        var players = new Gtk.ComboBoxText ();
        players.append_text ("player1");
        players.append_text ("player2");
        players.active = 0;

        return players;
    }

    Gtk.MenuButton build_preferences_button () {
        var preferences_button = new Gtk.MenuButton ();
        preferences_button.image = new Gtk.Image.from_icon_name ("open-menu-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
        //  preferences_button.popover = build_preferences_popover ();
        preferences_button.tooltip_text = _("Preferences");
        preferences_button.valign = Gtk.Align.CENTER;
        return preferences_button;
    }

    //  Gtk.Popover build_preferences_popover () {
    //  }

    Gtk.Button build_button_from_icon (string icon_name, string? tooltip = null) {
        var button = new Gtk.Button.from_icon_name (icon_name);
        if (tooltip != null) {
            button.tooltip_text = tooltip;
        }
        return button;
    }

    public override bool configure_event (Gdk.EventConfigure event) {
        int root_x, root_y;
        get_position (out root_x, out root_y);
        Application.settings.set_int ("window-x", root_x);
        Application.settings.set_int ("window-y", root_y);

        return base.configure_event (event);
    }
}
