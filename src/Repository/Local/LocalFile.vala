
public class Lyrics.LocalFile : Lyrics.ILyricFile, Object {
    File file;

    public LocalFile (File file) {
        this.file = file;
    }

    public string? get_metadata (string attribute) {
        return null;
    }

    public string get_content () {
        var builder = new StringBuilder ();
        try {
            var is = new DataInputStream (file.read ());
            string str;
            while ((str = is.read_line ()) != null) {
                builder.append (str);
            }
        } catch (Error e) {
            warning (e.message);
        }

        return builder.str;
    }

    public Lyrics.Lyric to_lyric () {
        return new Parser.LRC ().parse (file);
    }

    public string to_string () {
        var string_builder = new StringBuilder ();
        string_builder.append (@"Content:\n");
        string_builder.append (@"$(get_content ())\n");

        return string_builder.str;
    }
}
