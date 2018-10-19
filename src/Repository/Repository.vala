
public class Lyrics.Repository : IRepository, Object {
    string[] viewlyrics_dbus = { "org.lyricsources.LyricSourcePlugin.viewlyrics",
                                 "/org/lyricsources/LyricSourcePlugin/viewlyrics"};

    string local_storage = Environment.get_home_dir ()+"/.lyrics/";
    Gee.HashMap<string, LyricSourcesRepository> lyricsources = new Gee.ArrayList<LyricSourcesRepository> ();

    public Repository () {
        lyricsources["viewlyrics"] = new LyricSourcesRepository (viewlyrics_dbus[0], viewlyrics_dbus[1]);
    }

    public Gee.Collection<Lyric> find (Metasong song);
        return lyricsources["viewlyrics"].find ();
    }
}
