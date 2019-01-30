public interface SaveWindowStateMixin : Gtk.Window {
    public virtual void enable_restore_state (GLib.Settings settings) {
        configure_window (settings);
        configure_event.connect ((event) => on_configure_event (event, settings));
    }

    bool on_configure_event (Gdk.EventConfigure event, GLib.Settings settings) {
        int root_x, root_y;
        get_position (out root_x, out root_y);
        settings.set_int ("window-x", root_x);
        settings.set_int ("window-y", root_y);

        int width, height;
        get_size (out width, out height);
        settings.set_int ("window-width", width);
        settings.set_int ("window-height", height);

        //  Continue the event
        return false;
    }

    void configure_window (GLib.Settings settings) {
        var window_x = settings.get_int ("window-x");
        var window_y = settings.get_int ("window-y");
        var width = settings.get_int ("window-width");
        var height = settings.get_int ("window-height");

        if (window_x != -1 ||  window_y != -1) {
            this.move (window_x, window_y);
        }

        if (height + width > 0) {
            this.default_width = width;
            this.default_height = height;
        }
    }
}
