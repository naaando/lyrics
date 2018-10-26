public interface IDisplay : Gtk.Widget {
    public abstract string current_line { get; set; }
    public abstract void clear ();
}
