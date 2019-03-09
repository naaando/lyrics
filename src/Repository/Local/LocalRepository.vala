
public class Lyrics.LocalRepository : IRepository, Object {
    public string local_storage { get; set; default = Environment.get_home_dir () + "/.lyrics/"; }

    public bool save (Metasong song, ILyricFile lyric_file) {
        if (!validate_or_create_local_storage ()) {
            warning (@"Unable to save to $local_storage, verify your directory or choose another");
            return false;
        }

        var file = File.new_for_path (local_storage+get_filename_for_song (song));
        message (@"Saving file to $(file.get_path ())");
        try {
            var os = new DataOutputStream (file.create (FileCreateFlags.REPLACE_DESTINATION));
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
        var local_storage_directory = File.new_for_path (local_storage);

        //  Check if it exist and tries to create directory if not
        return local_storage_directory.query_exists () || local_storage_directory.make_directory_with_parents ();
    }

    string get_filename_for_song (Metasong song) {
        // string[0:-4] will slice the last 3 characters
        return song.filename[0:-4]+".lrc";
    }
}
