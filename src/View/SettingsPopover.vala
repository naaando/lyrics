public class Lyrics.SettingsPopover : Gtk.Popover {
    FileChooserButton folder_chooser_button;
    Gtk.ComboBox combobox;
    Gtk.Switch opacity_switch;

    public SettingsPopover () {
        var grid = new Gtk.Grid ();
        grid.margin = 12;
        grid.row_spacing = grid.column_spacing = 12;

        var lyrics_folder_label = new Gtk.Label ("Lyrics download folder:");
        folder_chooser_button = new FileChooserButton (_("Select folder to download lyrics"), Gtk.FileChooserAction.SELECT_FOLDER);
        var window_behavior_label = new Gtk.Label ("Keep window above:");
        combobox = create_combobox ();

        grid.attach (lyrics_folder_label, 0, 0);
        grid.attach (folder_chooser_button, 1, 0);
        grid.attach (window_behavior_label, 0, 1);
        grid.attach (combobox, 1, 1);
        grid.attach (create_translucid_switch (), 0, 2, 2);

        grid.show_all ();
        add (grid);

        Application.settings.bind ("download-location", folder_chooser_button, "filename", GLib.SettingsBindFlags.DEFAULT);
        Application.settings.bind ("window-keep-above", combobox, "active-id", GLib.SettingsBindFlags.DEFAULT);
        Application.settings.bind ("window-out-of-focus-translucid", opacity_switch, "active", GLib.SettingsBindFlags.DEFAULT);
    }

    Gtk.ComboBox create_combobox () {
        var combobox = new Gtk.ComboBoxText ();
        combobox.append ("Always", "Always");
        combobox.append ("When playing", "When playing");
        combobox.append ("Never keep above", "Never keep above");

        return combobox;
    }

    Gtk.Container create_translucid_switch () {
        var box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6);
        box.add (opacity_switch = new Gtk.Switch ());
        box.add (new Gtk.Label ("Make translucid on focus loss"));
        box.halign = Gtk.Align.CENTER;

        return box;
    }
}
