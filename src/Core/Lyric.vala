
public class Lyrics.Lyric : Object {
    private struct Metadata {
        string tag;
        string info;
    }

    private Metadata[] metadata = {};
    public Gee.TreeMap<uint64?, string> lines { get; private set; default = new Gee.TreeMap<uint64?, string> ();}

    public void add_metadata (string _tag, string _info) {
        metadata += Metadata () { tag = _tag, info = _info };
    }

    public void add_line (uint64 time, string text) {
        lines.set (time, text);
    }
    public string to_string () {
        var builder = new StringBuilder ();

        builder.append (@"Metadata:\n");
        foreach (var data in metadata) {
            builder.append (@"$(data.tag)");
            builder.append (@"$(data.info)");
        }

        builder.append (@"Lyric:\n");
        foreach (var line in lines) {
            builder.append (@"$line");
        }

        return builder.str;
    }
}
