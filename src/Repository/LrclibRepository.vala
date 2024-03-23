public class Lyrics.LrclibRepository : Lyrics.IRepository, Object {
    Soup.Session session;

    public LrclibRepository () {
        session = new Soup.Session ();
        session.user_agent = "Lyrics v0.9.x (https://)";
        session.use_thread_context = true;
    }

    public ILyricFile? find_first (SongMetadata song) {
        var shim = new SyncedLyrics.Shim ();

        var search_terms = new StringBuilder ();
        search_terms
        .append(song.title)
        .append(" ")
        .append(song.artist)
        .append(" ")
        .append(song.album);
        debug (@"Searching for $(search_terms.str)");

        var file = shim.search (search_terms.str, song.filename);
        return file != null ? new Lyrics.LocalFile(file) : null;
    }

    public Gee.Collection<ILyricFile>? find (SongMetadata song) {
        get_lrc(song);
        return null;
    }

    private void get_lrc(SongMetadata song)
    {
        MainLoop loop = new MainLoop ();

        var uri = new Soup.URI ("https://lrclib.net/api/get?");

        uri.set_query_from_fields (
            "artist_name", song.artist,
            "track_name", song.title,
            "album_name", song.album,
            "duration", song.duration.to_string ()
        );

        // Request a file:
        try {
            Soup.Request request = session.request (uri.to_string (false));
            request.send_async.begin (null, (obj, res) => {
                // print the content:
                try {
                    InputStream stream = request.send_async.end (res);

                    var data_stream = new DataInputStream (stream);

                    do {
                        var line = data_stream.read_line_utf8 ();
                        if (line == null) {
                            break;
                        }
                        stdout.printf ("%s\n", line);
                    } while (true);

                    loop.quit ();
                } catch (Error e) {
                    stderr.printf ("Error: %s\n", e.message);
                }
            });
        } catch (Error e) {
            stderr.printf ("Error: %s\n", e.message);
        }

        loop.run ();
    }
}
