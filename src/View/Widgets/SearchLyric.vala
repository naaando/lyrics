public class Lyrics.SearchLyric : Gtk.Dialog {
    public const int MIN_WIDTH = 600;
    public const int MIN_HEIGHT = 400;

    Metasong meta;

    private Gtk.Entry title_entry;
    private Gtk.Entry artist_entry;
    private Gtk.Entry album_entry;
    private Gtk.Entry genre_entry;
    private Gtk.SpinButton length_spinbutton;
    Gtk.TreeView lyrics_list;
    ListStore model = new ListStore ();

    private Gtk.Button search_button;
    private Gtk.Button close_button;

    public SearchLyric (Gtk.Window window, Metasong? metasong = null) {
        Object (
            deletable: false,
            destroy_with_parent: true,
            height_request: MIN_HEIGHT,
            resizable: true,
            transient_for: window,
            width_request: MIN_WIDTH,
            window_position: Gtk.WindowPosition.CENTER_ON_PARENT
        );

        meta = metasong ?? new Metasong ();
        lyrics_list = factory_treeview (model);

        //  model.row_activated.connect ((path, column) => {
        //      column.get_widget ();
        //  });

        title_entry = new Gtk.Entry ();
        title_entry.expand = true;
        artist_entry = new Gtk.Entry ();
        artist_entry.expand = true;
        album_entry = new Gtk.Entry ();
        album_entry.expand = true;
        genre_entry = new Gtk.Entry ();
        genre_entry.expand = true;
        length_spinbutton = new Gtk.SpinButton (null, 1, 1);

        //  bind_property (string source_property, Object target, string target_property, BindingFlags.BIDIRECTIONAL)
        var bind_flag = BindingFlags.SYNC_CREATE | BindingFlags.BIDIRECTIONAL;
        meta.bind_property ("title", title_entry.buffer, "text", bind_flag);
        meta.bind_property ("artist", artist_entry.buffer, "text", bind_flag);
        meta.bind_property ("album", album_entry.buffer, "text", bind_flag);
        //  meta.bind_property ("duration", length_spinbutton, , bind_flag);

        var grid = new Gtk.Grid ();
        grid.expand = true;
        grid.margin_start = 12;
        grid.margin_end = 12;
        grid.column_spacing = 12;

        grid.attach (new Granite.HeaderLabel (_("Title:")), 0, 0);
        grid.attach (title_entry, 0, 1);
        grid.attach (new Granite.HeaderLabel (_("Artist:")), 1, 0);
        grid.attach (artist_entry, 1, 1);
        grid.attach (new Granite.HeaderLabel (_("Album:")), 0, 2);
        grid.attach (album_entry, 0, 3);
        grid.attach (new Granite.HeaderLabel (_("Genre:")), 1, 2);
        grid.attach (genre_entry, 1, 3);
        grid.attach (new Granite.HeaderLabel (_("Length:")), 1, 4);
        grid.attach (length_spinbutton, 1, 5);
        grid.attach (lyrics_list, 0, 6, 2, 2);

        var content = get_content_area () as Gtk.Container;
        content.add (grid);

        close_button = (Gtk.Button) add_button (_("Close"), Gtk.ResponseType.CLOSE);
        search_button = (Gtk.Button) add_button (_("Search"), Gtk.ResponseType.APPLY);
        search_button.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);

        close_button.clicked.connect (() => destroy ());
        search_button.clicked.connect (search);
    }

    private void search () {
        var repository = new Repository ();
        repository.find (meta).foreach ((item) => {
            model.add (item as LyricsSources.RemoteFile);
            return true;
        });
    }

    Gtk.TreeView factory_treeview (Gtk.TreeModel? model = null) {
        var view = (model == null) ? new Gtk.TreeView () : new Gtk.TreeView.with_model (model);
        Gtk.CellRendererText cell = new Gtk.CellRendererText ();
        view.insert_column_with_attributes (-1, "Title", cell, "text", 0);
        view.insert_column_with_attributes (-1, "Lenght", cell, "text", 1);
        view.insert_column_with_attributes (-1, "Artist", cell, "text", 2);
        view.insert_column_with_attributes (-1, "Album", cell, "text", 3);
        view.insert_column_with_attributes (-1, "Genre", cell, "text", 4);

        return view;
    }

    class ListStore : Gtk.ListStore {
        public ListStore () {
            Type[] types = {
                typeof (string),
                typeof (string),
                typeof (string),
                typeof (string),
                typeof (string)
            };
            set_column_types (types);
        }

        public void add (LyricsSources.RemoteFile remote_file) {
            var title = remote_file.metadata["title"].get_string ();
            var artist = remote_file.metadata["artist"].get_string ();
            var album = remote_file.metadata["album"].get_string ();

            Gtk.TreeIter iter;
            append (out iter);
            set (iter, 0, title??"", 1, "", 2, artist??"", 3, album??"", 4, "");
        }
    }
}
