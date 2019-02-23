
public class Lyrics.Repository : IRepository, Object {
    string[] viewlyrics_dbus = { "org.lyricsources.LyricSourcePlugin.viewlyrics",
                                 "/org/lyricsources/LyricSourcePlugin/viewlyrics"};

    Gee.HashMap<string, LyricSources.Repository> lyricsources = new Gee.HashMap<string, LyricSources.Repository> ();
    LocalRepository local_repository = new LocalRepository ();

    public Repository () {
        lyricsources["viewlyrics"] = new LyricSources.Repository (viewlyrics_dbus[0], viewlyrics_dbus[1]);

        Application.settings.changed["download-location"].connect (configure_download_local);
        configure_download_local ();
    }

    public ILyricFile? find_first (Metasong song_metadata) {
        var local_file = local_repository.find_first (song_metadata);
        if (local_file != null) {
            return local_file;
        }

        var remote_file = lyricsources["viewlyrics"].find_first (song_metadata);
        if (remote_file != null) {
            save (song_metadata, remote_file);
            return remote_file;
        }

        return null;
    }

    public bool save (Metasong song_metadata, Lyrics.ILyricFile lyric) {
        return local_repository.save (song_metadata, lyric);
    }

    public Gee.Collection<ILyricFile>? find (Metasong song) {
        var collection = new Gee.ArrayList<ILyricFile> ();
        var local_result = local_repository.find_first (song);
        if (local_result != null) collection.add (local_result);

        var viewlyrics_results = lyricsources["viewlyrics"].find (song);
        if (viewlyrics_results != null) collection.add_all (viewlyrics_results);

        return collection.size != 0 ? collection : null;
    }

    void configure_download_local () {
        var settings_location = Application.settings.get_string ("download-location");
        local_repository.local_storage = settings_location == "" ? Environment.get_home_dir ()+"/.lyrics/" : settings_location+"/";
        debug ("Setting local storage to " + local_repository.local_storage);
    }
}
