public class Lyrics.SyncedLyricsRepository : Lyrics.IRepository, Object {

    public SyncedLyricsRepository () {
        //
    }

    public ILyricFile? find_first (Metasong song) {
        var shim = new SyncedLyrics.Shim ();

        var search_terms = new StringBuilder ();
        search_terms
        .append(song.title)
        .append(" ")
        .append(song.artist)
        .append(" ")
        .append(song.album);
        debug (@"Searching for $(search_terms.str)");

        var file = shim.search (search_terms.str );
        return file != null ? new Lyrics.LocalFile(file) : null;
    }

    public Gee.Collection<ILyricFile>? find (Metasong song) {
        return null;
    }
}