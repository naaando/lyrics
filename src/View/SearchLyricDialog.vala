public class Lyrics.SearchLyric : Gtk.Dialog {
    public LyricsService? lyrics_service { get; set; }

    Repository repository = new Repository ();
    Gee.HashMap<int, LyricsSources.RemoteFile> result = new Gee.HashMap<int, LyricsSources.RemoteFile> ();
    Metasong song_metadata;

    Gtk.Entry title_entry = new Gtk.Entry ();
    Gtk.Entry artist_entry = new Gtk.Entry ();
    Gtk.Entry album_entry = new Gtk.Entry ();
    Gtk.TreeView lyrics_list;
    Gtk.ListStore lyrics_list_store;

    public SearchLyric (Gtk.Window window, Metasong? metasong = null) {
        Object (
            deletable: false,
            destroy_with_parent: true,
            resizable: true,
            transient_for: window,
            default_height: 400,
            default_width: 400,
            window_position: Gtk.WindowPosition.CENTER_ON_PARENT
        );

        song_metadata = metasong ?? new Metasong ();
        lyrics_list = create_treeview (lyrics_list_store = create_metadata_song_list_store ());
        lyrics_list.expand = true;
        lyrics_list.row_activated.connect (on_row_activated);

        var bind_flag = BindingFlags.SYNC_CREATE | BindingFlags.BIDIRECTIONAL;
        song_metadata.bind_property ("title", title_entry.buffer, "text", bind_flag);
        song_metadata.bind_property ("artist", artist_entry.buffer, "text", bind_flag);
        song_metadata.bind_property ("album", album_entry.buffer, "text", bind_flag);

        var content = get_content_area () as Gtk.Container;
        content.add (create_song_form ());

        var close_button = (Gtk.Button) add_button (_("Close"), Gtk.ResponseType.CLOSE);
        var search_button = (Gtk.Button) add_button (_("Search"), Gtk.ResponseType.APPLY);
        search_button.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);

        close_button.clicked.connect (() => destroy ());

        search_button.clicked.connect (() => {
            result.clear ();
            lyrics_list_store.clear ();
            search ();
        });
    }

    void on_row_activated (Gtk.TreePath path, Gtk.TreeViewColumn column) {
        Gtk.TreeIter iter;

        if (lyrics_list_store.get_iter (out iter, path) && lyrics_list_store.iter_is_valid (iter)) {
            Value val;
            lyrics_list_store.get_value (iter, 0, out val);
            var id = val.get_int ();
            debug (@"Retrieving lyric for row id $id\n");

            repository.save (song_metadata, result[id]);
            lyrics_service.push_lyric (result[id].to_lyric ());
        }
    }

    Gtk.Container create_song_form () {
        var grid = new Gtk.Grid ();
        grid.hexpand = true;
        grid.margin_start = 12;
        grid.margin_end = 12;
        grid.column_spacing = 12;
        grid.row_spacing = 12;

        var scrollable_lyric_list = new Gtk.ScrolledWindow (null, null);
        scrollable_lyric_list.add (lyrics_list);

        grid.attach (new Gtk.Label (_("Title:")), 0, 0);
        grid.attach (title_entry, 1, 0);
        grid.attach (new Gtk.Label (_("Artist:")), 0, 1);
        grid.attach (artist_entry, 1, 1);
        grid.attach (new Gtk.Label (_("Album:")), 0, 2);
        grid.attach (album_entry, 1, 2);
        grid.attach (scrollable_lyric_list, 0, 3, 2, 2);

        return grid;
    }

    void search () {
        print (@"Searching for $song_metadata\n");
        var lyric_result = repository.find (song_metadata);

        if (lyric_result == null) return;
        lyric_result.foreach ((item) => {
            if (item != null && item is LyricsSources.RemoteFile) {
                add_result_to_tree_view (item as LyricsSources.RemoteFile);
            }
            return true;
        });
    }

    Gtk.TreeView create_treeview (Gtk.TreeModel model = create_metadata_song_list_store ()) {
        var view = new Gtk.TreeView.with_model (model);
        Gtk.CellRendererText cell = new Gtk.CellRendererText ();
        view.insert_column_with_attributes (-1, "Title", cell, "text", 1);
        view.insert_column_with_attributes (-1, "Artist", cell, "text", 2);
        view.insert_column_with_attributes (-1, "Album", cell, "text", 3);

        return view;
    }

    Gtk.ListStore create_metadata_song_list_store () {
        var list_store = new Gtk.ListStore.newv ({
            typeof (int),     // Local ID
            typeof (string),  // Title
            typeof (string),  // Artist
            typeof (string),  // Album
        });

        return list_store;
    }

    void add_result_to_tree_view (LyricsSources.RemoteFile remote_file) {
        var id = result.size + 1;
        var title  = remote_file.metadata["title"].get_string ()  ?? "";
        var artist = remote_file.metadata["artist"].get_string () ?? "";
        var album  = remote_file.metadata["album"].get_string ()  ?? "";

        result[id] = remote_file;

        Gtk.TreeIter iter;
        lyrics_list_store.append (out iter);
        lyrics_list_store.set (iter,
            0, id,
            1, title,
            2, artist,
            3, album,
            -1
        );
    }
}
