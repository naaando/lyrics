
public class Lyrics.LocalRepository : IRepository, Object {
    string local_storage = Environment.get_home_dir ()+"/.lyrics/";

    public bool save (Metasong song, ILyricFile lyric_file) {
        var file = File.new_for_path (get_filename_for_song (song));
        message (@"Saving file to $(file.get_path ())");
        try {
            var os = new DataOutputStream (file.create (FileCreateFlags.REPLACE_DESTINATION));
            os.put_string (lyric_file.get_content ());
            message ("Finished saving file to $(file.get_path ())");
            return true;
        } catch (Error e) {
            warning (e.message);
            return false;
        }
    }

    //  public Gee.Collection<ILyricFile> all () {}

    public ILyricFile? find_first (Metasong song) {
        var file = File.new_for_path (get_filename_for_song(song));
        message (@"looking for lyric file: $(file.get_basename ())");

        if (file.query_exists ()) {
            return new LocalFile (file);
        }
        return null;
    }

    public Gee.Collection<ILyricFile>? find (Metasong song) {
        return null;
    }

    string get_filename_for_song (Metasong song) {
        // string[0:-4] will slice the last 3 characters
        return local_storage+song.filename[0:-4]+".lrc";
    }
}
