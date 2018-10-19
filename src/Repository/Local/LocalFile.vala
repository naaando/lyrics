
public class Lyrics.LocalFile : Lyrics.ILyricFile, Object {
    string content;
    File file;

    public LocalFile (File file) {
        this.file = file;
    }

    public void load () {
        var builder = new StringBuilder ();
        try {
            var is = new DataInputStream(file.read ());
            string str;
            while ((str = is.read_line_utf8 ()) != null) {
                print (@"$str\n");
                builder.append (str);
            }
        } catch (Error e) {
            warning (e.message);
        }

        content = builder.str;
    }

    public string get_content () {
        if (content == null) {
            try {
                load ();
            } catch (Error e) {
                warning (e.message);
            }
        }

        return content;
    }

    public Lyrics.Lyric to_lyric () {
        print (@"Content:\n");
        print (@"$(get_content ())\n");
        var lrc = new Parser.LRC ().parse_string (content);
        return lrc;
    }

    public string to_string () {
        var string_builder = new StringBuilder ();
        string_builder.append (@"Content:\n");
        string_builder.append (@"$(get_content ())\n");

        return string_builder.str;
    }
}
