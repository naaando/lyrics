public class Lyrics.ThemeEditorDialog : Gtk.Dialog {
    Gtk.StackSwitcher stack_switcher = new Gtk.StackSwitcher ();
    Gtk.Stack stack = new Gtk.Stack ();
    Settings light_theme_settings;
    Settings dark_theme_settings;

    public ThemeEditorDialog (Gtk.Window window) {
        transient_for = window;
        destroy_with_parent = true;

        var content_area = get_content_area () as Gtk.Container;
        content_area.margin = 6;

        light_theme_settings = Application.settings.get_child ("light-theme");
        dark_theme_settings = Application.settings.get_child ("dark-theme");

        stack.add_titled (create_theme_editor (light_theme_settings), "light", "Light theme");
        stack.add_titled (create_theme_editor (dark_theme_settings), "dark", "Dark theme");
        stack_switcher.stack = stack;
        stack_switcher.halign = Gtk.Align.CENTER;

        content_area.add (stack_switcher);
        content_area.add (stack);

        Idle.add (() => {
            stack.visible_child_name = Application.settings.get_boolean ("dark") ? "dark" : "light";

            Application.settings.bind_with_mapping ("dark", stack, "visible_child_name",
                                                    SettingsBindFlags.DEFAULT,
                                                    map_from_settings,
                                                    map_to_settings,
                                                    null, null);

            return false;
        });
    }

    ~ ThemeEditorDialog () {
        //  Application.settings.unbind (stack, "dark");
        print (@"Running out\n");
    }

    Gtk.Widget create_theme_editor (Settings settings) {
        var grid = new Gtk.Grid ();
        grid.margin = 12;
        grid.column_spacing = 6;
        grid.row_spacing = 6;
        grid.row_homogeneous = true;

        grid.attach (get_color_btn (settings, "font-color"), 0, 0);
        grid.attach (new Gtk.Label ("Font color"), 1, 0);
        grid.attach (get_color_btn (settings, "font-color-active"), 0, 1);
        grid.attach (new Gtk.Label ("Active line"), 1, 1);

        grid.attach (get_color_btn (settings, "background-color"), 0, 3);
        grid.attach (new Gtk.Label ("Background color"), 1, 3);
        grid.attach (get_color_btn (settings, "background-second-color"), 0, 4);
        grid.attach (new Gtk.Label ("2nd color"), 1, 4);

        grid.attach (get_color_btn (settings, "backdrop-background-color", true), 0, 5);
        grid.attach (new Gtk.Label ("Backdrop background color"), 1, 5);

        grid.foreach ((widget) => {
            if (widget is Gtk.Label) {
                widget.halign = Gtk.Align.START;
            }
        });

        return grid;
    }

    Gtk.ColorButton get_color_btn (Settings settings, string settings_key, bool use_alpha = false) {
        var color_btn = new Gtk.ColorButton.with_rgba (parse_color_from_settings (settings, settings_key));
        color_btn.use_alpha = use_alpha;
        color_btn.color_set.connect (() => {
            settings.set_string (settings_key, color_btn.rgba.to_string ());
            print (@"New color for key $settings_key set: $(settings.get_string (settings_key))\n");
        });

        //  settings.changed[settings_key].connect (() => {
        //      color_btn.rgba.parse (settings.get_string (settings_key));
        //  });

        return color_btn;
    }

    Gdk.RGBA? parse_color_from_settings (Settings settings, string settings_key) {
        Gdk.RGBA color = Gdk.RGBA ();
        color.parse (settings.get_string (settings_key));
        return color;
    }

    static bool map_from_settings (Value value, Variant? variant, void* user_data) {
        value.set_string (variant.get_boolean () ? "dark" : "light");
        return true;
    }

    static Variant map_to_settings (Value value, VariantType expected_type, void* user_data) {
        return new Variant.boolean (value.get_string () == "dark");
    }
}
