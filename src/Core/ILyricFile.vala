public interface Lyrics.ILyricFile : Object {
    public abstract string? get_metadata (string attribute_name);
    public abstract string get_content ();
    public abstract Lyric to_lyric ();
}
