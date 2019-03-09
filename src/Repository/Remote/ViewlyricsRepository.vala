public class Remote.ViewlyricsRepository : Lyrics.IRepository, Object {
    public Lyrics.ILyricFile? find_first (Lyrics.Metasong song) {
        var res = find (song);

        return (res != null && !res.is_empty) ? res.first_match (() => { return true; }) : null;
    }

    public Gee.Collection<Lyrics.ILyricFile>? find (Lyrics.Metasong song) {
        return null;
    }
}
