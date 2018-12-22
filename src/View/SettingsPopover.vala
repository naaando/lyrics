public class Lyrics.SettingsPopover : Gtk.Popover {
    public SettingsPopover () {
        var grid = new Gtk.Grid ();
        grid.margin = 12;
        grid.row_spacing = grid.column_spacing = 12;

        var lyrics_folder_label = new Gtk.Label ("Lyrics download folder:");
        var folder_chooser = new Gtk.FileChooserButton (_("Select folder to download lyrics"), Gtk.FileChooserAction.SELECT_FOLDER);
        var window_behavior_label = new Gtk.Label ("Keep window above:");

        grid.attach (lyrics_folder_label, 0, 0);
        grid.attach (folder_chooser, 1, 0);
        grid.attach (window_behavior_label, 0, 1);
        grid.attach (create_radio_button_container (), 1, 1);
        grid.attach (create_translucid_switch (), 0, 2, 2);

        grid.show_all ();
        add (grid);
    }

    Gtk.Container create_radio_button_container () {
        var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 6);
        var op1 = new Gtk.RadioButton.with_label_from_widget (null, "Always");
        var op2 = new Gtk.RadioButton.with_label_from_widget (op1, "When playing");
        var op3 = new Gtk.RadioButton.with_label_from_widget (op2, "Never keep above");

        box.add (op1);
        box.add (op2);
        box.add (op3);

        return box;
    }

    Gtk.Container create_translucid_switch () {
        var box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6);
        box.add (new Gtk.Switch ());
        box.add (new Gtk.Label ("Make translucid on focus loss"));
        box.halign = Gtk.Align.CENTER;

        return box;
    }
}
