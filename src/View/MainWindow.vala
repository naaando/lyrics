
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

        configure_css_provider ();

        //  Add css classes to main window
        get_style_context ().add_class ("rounded");
        get_style_context ().add_class ("lyrics");

        set_titlebar (new Lyrics.HeaderBar ());
        set_keep_above (true);
        stick ();

        add (stack);
    }

    public override bool configure_event (Gdk.EventConfigure event) {
        int root_x, root_y;
        get_position (out root_x, out root_y);
        Application.settings.set_int ("window-x", root_x);
        Application.settings.set_int ("window-y", root_y);

        return base.configure_event (event);
    }

    void configure_css_provider () {
        var provider = new Gtk.CssProvider ();
        provider.load_from_resource ("/com/github/naaando/lyrics/Application.css");
        Gtk.StyleContext.add_provider_for_screen (Gdk.Screen.get_default (), provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);
    }
}
