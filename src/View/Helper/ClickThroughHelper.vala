public class ClickThroughHelper : Object {
    Gtk.Window window;
    Gtk.Widget? titlebar;
    ulong window_event_handler_id = 0;
    bool inactive_only;
    bool clickable_headerbar;

    /**
     * Make click pass through the window
     *
     * @param Gtk.Window
     * @param Makes the window headerbar clickable to possibilite moving window and
     * recovering focus on window
     */
    public ClickThroughHelper (Gtk.Window window, bool clickable_headerbar = true) {
        this.window = window;
        this.titlebar = window.get_titlebar ();
        this.clickable_headerbar = clickable_headerbar;
    }

    public void enable (bool inactive_only = true) {
        this.inactive_only = inactive_only;

        mask_input ();
        window_event_handler_id = window.event.connect (listen_to_window_events);
    }

    public void disable () {
        if (window_event_handler_id > 0) {
            window.disconnect (window_event_handler_id);
        }
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

    Cairo.Region create_mask () {
        Cairo.RectangleInt rect_int;
        if (clickable_headerbar && get_titlebar () != null) {
            titlebar.get_allocation (out rect_int);
        } else {
            rect_int = {0, 0, 0, 0};
        }

        var region = new Cairo.Region.rectangle (rect_int);
        return region;
    }

    Gtk.Widget? get_titlebar () {
        if (titlebar == null) {
            titlebar = window.get_titlebar ();
        }

        return titlebar;
    }
}
