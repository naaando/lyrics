
public class Lyrics.LocalRepository : IRepository, Object {
    public string local_storage { get; set; default = Environment.get_home_dir () + "/.lyrics/"; }

    public bool save (Metasong song, ILyricFile lyric_file) {
        validate_or_create_local_storage ();
        var file = File.new_for_path (local_storage+get_filename_for_song (song));
        message (@"Saving file to $(file.get_path ())");
        try {
            var os = new DataOutputStream (file.replace (null, false, FileCreateFlags.REPLACE_DESTINATION));
            os.put_string (lyric_file.get_content ());
            message (@"Finished saving file to $(file.get_path ())");
            return true;
        } catch (Error e) {
            warning (e.message);
            return false;
        }
    }

    public ILyricFile? find_first (Metasong song) {
        return find_by_filename (get_filename_for_song(song));
    }

    public Gee.Collection<ILyricFile>? find (Metasong song) {
        return null;
    }

    public ILyricFile? find_by_filename (string filename) {
        var file = File.new_for_path (local_storage+filename);
        message (@"looking for lyric file: $(file.get_basename ())");

        if (file.query_exists ()) {
            return new LocalFile (file);
        }
        return null;
    }

    public bool validate_or_create_local_storage () {
        var local_storage_file = File.new_for_path (local_storage);

        //  Check if it exist and tries to create directory if not
        return local_storage_file.query_exists () || local_storage_file.make_directory_with_parents ();
    }

    string get_filename_for_song (Metasong song) {
        // string[0:-4] will slice the last 3 characters
        return song.filename[0:-4]+".lrc";
    }
}
