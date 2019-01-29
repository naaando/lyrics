
public class Lyrics.MainWindow : Gtk.ApplicationWindow {
    Gtk.Stack main_stack;
    Players players;
    bool keep_above_when_playing;

    public MainWindow (Gtk.Application application, Players _players, Gtk.Stack stack) {
        Object (
            application: application,
            icon_name: "com.github.naaando.lyrics",
            resizable: true,
            title: _("Lyrics"),
            window_position: Gtk.WindowPosition.CENTER
        );

        //  Add css classes to main window
        get_style_context ().add_class ("rounded");
        get_style_context ().add_class ("lyrics");

        main_stack = stack;
        players = _players;

        set_titlebar (new Lyrics.HeaderBar (players));

        Application.settings.changed["window-keep-above"].connect (configure_window_keep_above_settings);
        Application.settings.changed["window-out-of-focus-translucid"].connect (configure_window_opacity_on_focus_loss);
        Application.settings.changed["font"].connect (configure_font);
        main_stack.notify["visible-child-name"].connect (on_stack_visible_child_changed);

        add (main_stack);
        setup ();
    }

    public override bool configure_event (Gdk.EventConfigure event) {
        int root_x, root_y;
        get_position (out root_x, out root_y);
        Application.settings.set_int ("window-x", root_x);
        Application.settings.set_int ("window-y", root_y);

        return base.configure_event (event);
    }

    void setup () {
        configure_dark_theme ();
        configure_css_provider ();
        configure_window_keep_above_settings ();
        configure_window_opacity_on_focus_loss ();
        configure_font ();
        stick ();
    }

    void configure_css_provider () {
        var provider = new Gtk.CssProvider ();
        provider.load_from_resource ("/com/github/naaando/lyrics/Application.css");
        Gtk.StyleContext.add_provider_for_screen (Gdk.Screen.get_default (), provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);
    }

    void configure_dark_theme () {
        update_dark_mode ();
        Application.settings.changed["dark"].connect (update_dark_mode);
    }

    void update_dark_mode () {
        if (Application.settings.get_boolean ("dark")) {
            get_style_context ().add_class ("dark");
        } else {
            get_style_context ().remove_class ("dark");
        }
    }

    void configure_window_keep_above_settings () {
        switch (Application.settings.get_string ("window-keep-above")) {
            case "Always":
                set_keep_above (true);
                keep_above_when_playing = false;
                break;
            case "When playing":
                keep_above_when_playing = true;
                set_keep_above (should_keep_above ());
                break;
            case "Never keep above":
                set_keep_above (false);
                keep_above_when_playing = false;
                break;
        }
    }

    void configure_window_opacity_on_focus_loss () {
        if (Application.settings.get_boolean ("window-out-of-focus-translucid")) {
            get_style_context ().add_class ("translucid-backdrop");
        } else {
            get_style_context ().remove_class ("translucid-backdrop");
        }
    }

    void configure_font () {
        var font = Application.settings.get_string ("font");
        if (font == "") return;

        var fd = Pango.FontDescription.from_string (font);
        var font_family = fd.get_family ();
        var font_weight = ((int) fd.get_weight ()).to_string ();
        var font_style = (fd.get_style ()).to_string ().substring(12).down ();
        var font_size = (fd.get_size () / Pango.SCALE).to_string () + "px";

        var provider = new Gtk.CssProvider ();
        provider.load_from_data (@".lyrics .display { font-family: $(font_family); font-weight: $(font_weight); font-size: $(font_size); font-style: $(font_style); }");
        Gtk.StyleContext.add_provider_for_screen (Gdk.Screen.get_default (), provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);
    }

    void on_stack_visible_child_changed () {
        if (keep_above_when_playing) {
            set_keep_above (should_keep_above ());
        }
    }

    bool should_keep_above () {
        return main_stack.visible_child_name == "DISPLAYING" ? true : false;
    }
}
