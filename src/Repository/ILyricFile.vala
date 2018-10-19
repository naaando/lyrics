public interface Lyrics.ILyricFile : Object {
    public abstract string get_content ();
    public abstract void load () throws Error;
    public abstract Lyric to_lyric ();
}
