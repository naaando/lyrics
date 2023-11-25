public class Lyrics.SyncedLyricsRepository : Lyrics.IRepository, Object {

    public SyncedLyricsRepository () {
        //
    }

    public ILyricFile? find_first (Metasong song) {
        var shim = new SyncedLyrics.Shim ();
        print (@"Looking up for $(song.artist) - $(song.title)");
        var file = shim.search (song.artist, song.title);
        return file != null ? new Lyrics.LocalFile(file) : null;
    }

    public Gee.Collection<ILyricFile>? find (Metasong song) {
        return null;
    }
}