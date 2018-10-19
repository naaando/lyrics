
public class Lyrics.LocalRepository : IRepository, Object {
    string local_storage = Environment.get_home_dir ()+"/.lyrics/";

    public abstract ILyricFile find_first (Metasong song) {
        // string[0:-4] will slice the last 3 characters
        var file_path = local_storage+song.filename[0:-4]+".lrc";
        print (@"$file_path\n");
        var file = File.new_for_path (file_path);
        message (@"looking for lyric file: $(file.get_basename ())");
        if (!file.query_exists ()) {
            return null;
        }
    }

    public Gee.Collection<ILyricFile> find (Metasong song) {
        var collection = new Gee.ArrayList<ILyricFile> ();
        collection.add (find_first (song));
        return collection;
    }
}
