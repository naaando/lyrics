public class Lyrics.ThemeLoader : Object {
    public Gtk.CssProvider style_provider { get; private set; }
    string light_theme_colors;
    string dark_theme_colors;
    Settings light_theme;
    Settings dark_theme;


    public ThemeLoader () {
        style_provider = new Gtk.CssProvider ();

        light_theme = Application.settings.get_child ("light-theme");
        dark_theme = Application.settings.get_child ("dark-theme");

        configure_themes ();
        light_theme.changed.connect (configure_themes);
        dark_theme.changed.connect (configure_themes);
    }

    void configure_themes () {
        print (@"Configuring themes\n");
        light_theme_colors = configure_theme ("lyrics", light_theme);
        dark_theme_colors = configure_theme ("lyrics_dark", dark_theme);

        try {
            style_provider.load_from_data (light_theme_colors + dark_theme_colors);
        } catch (Error e) {
            error ("Was not possible to parse due to error: " + e.message);
        }
    }

    string configure_theme (string prefix, Settings settings) {
        string theme = "";

        if (settings.get_string ("font-color") != "") {
            theme += build_color (prefix + "_color", settings.get_string ("font-color"));
        }

        if (settings.get_string ("font-color-active") != "") {
            theme += build_color (prefix + "_active_color", settings.get_string ("font-color-active"));
        }

        if (settings.get_string ("background-color") != "") {
            theme += build_color (prefix + "_bg_color", settings.get_string ("background-color"));
        }

        if (settings.get_string ("background-second-color") != "") {
            theme += build_color (prefix + "_bg_nd_color", settings.get_string ("background-second-color"));
        }

        if (settings.get_string ("backdrop-background-color") != "") {
            theme += build_color (prefix + "_backdrop_bg_color", settings.get_string ("backdrop-background-color"));
        }

        return theme;
    }

    string build_color (string color_name, string color_value) {
        return @"@define-color $color_name $color_value;";
    }
}
