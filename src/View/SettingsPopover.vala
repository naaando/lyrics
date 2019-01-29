public class Lyrics.SettingsPopover : Gtk.Popover {
    FileChooserButton folder_chooser_button;
    Gtk.ComboBox combobox;
    Gtk.Switch opacity_switch;

    public SettingsPopover () {
        var grid = new Gtk.Grid ();
        grid.margin = 12;
        grid.row_spacing = grid.column_spacing = 12;

        var font_selection_label = new Gtk.Label (_("Select custom font:"));
        var font_selection_btn = new Gtk.FontButton ();

        var lyrics_folder_label = new Gtk.Label (_("Lyrics download folder:"));
        folder_chooser_button = new FileChooserButton (_("Select folder to download lyrics"), Gtk.FileChooserAction.SELECT_FOLDER);
        try {
            folder_chooser_button.add_shortcut_folder (Application.DEFAULT_LYRICS_DIR);
        } catch (Error e) {
            info (_("Couldn't add default lyrics folder to FileChooserButton") + " " + e.message);
        }

        var window_behavior_label = new Gtk.Label (_("Keep window above:"));
        window_behavior_label.halign = Gtk.Align.START;

        combobox = create_combobox ();
        var reset_default_button = create_reset_button ();

        grid.attach (font_selection_label, 0, 0);
        grid.attach (font_selection_btn, 1, 0);
        grid.attach (lyrics_folder_label, 0, 1);
        grid.attach (folder_chooser_button, 1, 1);
        grid.attach (window_behavior_label, 0, 2);
        grid.attach (combobox, 1, 2);
        grid.attach (create_translucid_switch (), 0, 3, 2);
        grid.attach (reset_default_button, 0, 4, 2);
        grid.show_all ();

        add (grid);

        Application.settings.bind ("download-location", folder_chooser_button, "filename", GLib.SettingsBindFlags.DEFAULT);
        Application.settings.bind ("window-keep-above", combobox, "active-id", GLib.SettingsBindFlags.DEFAULT);
        Application.settings.bind ("window-out-of-focus-translucid", opacity_switch, "active", GLib.SettingsBindFlags.DEFAULT);
        Application.settings.bind ("font", font_selection_btn, "font", GLib.SettingsBindFlags.DEFAULT);
    }

    Gtk.ComboBox create_combobox () {
        var combobox = new Gtk.ComboBoxText ();
        combobox.append ("Always", _("Always"));
        combobox.append ("When playing", _("When playing"));
        combobox.append ("Never keep above", _("Never keep above"));

        return combobox;
    }

    Gtk.Container create_translucid_switch () {
        var box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6);
        box.add (opacity_switch = new Gtk.Switch ());
        box.add (new Gtk.Label (_("Make translucid on focus loss")));
        box.halign = Gtk.Align.START;

        return box;
    }

    Gtk.Button create_reset_button () {
        var btn = new Gtk.Button.with_label (_("Restore default settings"));
        btn.halign = Gtk.Align.CENTER;
        btn.get_style_context ().add_class (Gtk.STYLE_CLASS_DESTRUCTIVE_ACTION);
        btn.clicked.connect (() => {
            Application.settings.set_string ("download-location", Application.DEFAULT_LYRICS_DIR);
            Application.settings.reset ("window-keep-above");
            Application.settings.reset ("window-out-of-focus-translucid");
        });

        return btn;
    }
}
