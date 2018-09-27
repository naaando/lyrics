
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
}
