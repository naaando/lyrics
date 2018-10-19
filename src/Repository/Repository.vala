
public class Lyrics.Repository : IRepository, Object {
    string[] viewlyrics_dbus = { "org.lyricsources.LyricSourcePlugin.viewlyrics",
                                 "/org/lyricsources/LyricSourcePlugin/viewlyrics"};

    string local_storage = Environment.get_home_dir ()+"/.lyrics/";
    Gee.HashMap<string, LyricSources.Repository> lyricsources = new Gee.HashMap<string, LyricSources.Repository> ();

    public Repository () {
        lyricsources["viewlyrics"] = new LyricSources.Repository (viewlyrics_dbus[0], viewlyrics_dbus[1]);
    }

    public Gee.Collection<ILyricFile> find (Metasong song) {
        return lyricsources["viewlyrics"].find (song);
    }
}
