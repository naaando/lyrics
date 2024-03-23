public class SyncedLyricsRepository : IRepository, Object {

    public SyncedLyricsRepository () {
        //
    }

    public ILyricFile? find_first (SongMetadata song) {
        var shim = new SyncedLyricsShim ();

        var search_terms = new StringBuilder ();
        search_terms
        .append(song.title)
        .append(" ")
        .append(song.artist)
        .append(" ")
        .append(song.album);
        debug (@"Searching for $(search_terms.str)");

        var file = shim.search (search_terms.str, song.filename);
        return file != null ? new LocalFile(file) : null;
    }

    public Gee.Collection<ILyricFile>? find (SongMetadata song) {
        return null;
    }
}
