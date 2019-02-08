public class ClickThroughHelper : Object {
    Gtk.Window window;
    ulong signal_id;
    bool inactive_only;

    public ClickThroughHelper (Gtk.Window window) {
        this.window = window;
    }

    public void enable (bool inactive_only = true) {
        this.inactive_only = inactive_only;

        mask_input ();
        signal_id = window.event.connect (listen_to_window_events);
    }

    public void disable () {
        window.disconnect (signal_id);
        window.input_shape_combine_region (null);
    }

    void mask_input () {
        window.input_shape_combine_region (!inactive_only || !window.is_active ? create_mask () : null);
    }

    bool listen_to_window_events (Gdk.Event event) {
        if (event.type == Gdk.EventType.WINDOW_STATE) {
            mask_input ();
        }

        //  Propagate event
        return false;
    }

    /**
     * Create a region with the window size
     *
     * @return cairo region with window size
     */
    Cairo.Region create_mask () {
        int width, height;
        window.get_size (out width, out height);
        var event_mask = new Cairo.ImageSurface (Cairo.Format.ARGB32, width, height);

        return Gdk.cairo_region_create_from_surface (event_mask);
    }
}
