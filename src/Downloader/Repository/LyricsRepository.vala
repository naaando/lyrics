
public class Lyrics.Repository : Object {
    string local_storage = Environment.get_home_dir ()+"/.lyrics/";
    //  Finder finder = new Finder ();

    public Lyric? find (Metasong song) {
        return find_by_filename (song.filename)??find_on_web (song);
    }

    private Lyric? find_on_web (Metasong song) {
        //  finder.search (song);
        return null;
    }

    private Lyric? find_by_filename (string filename) {
        var parser = new Parser.LRC ();

        // string[0:-4] will slice the last 3 characters
        var file = File.new_for_path (local_storage+filename[0:-4]+".lrc");
        message (@"looking for lyric file: $(file.get_basename ())");

        if (!file.query_exists ()) {
            return null;
        }

        return parser.parse (file);
    }
}
