
public class Lyrics.MainWindow : Gtk.Window {
    public MainWindow (Gtk.Application application, Lyrics.Stack stack) {
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

        var randomize_button = new Gtk.Button.from_icon_name ("media-playlist-shuffle-symbolic");
        randomize_button.margin_end = 12;
        randomize_button.tooltip_text = _("Load a random principle");

        header.pack_end (mode_switch);
        header.pack_end (randomize_button);

        return header;
    }

    public override bool configure_event (Gdk.EventConfigure event) {
        int root_x, root_y;
        get_position (out root_x, out root_y);
        Application.settings.set_int ("window-x", root_x);
        Application.settings.set_int ("window-y", root_y);

        return base.configure_event (event);
    }
}
