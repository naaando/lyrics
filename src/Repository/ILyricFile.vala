public interface Lyrics.ILyricFile : Object {
    public abstract string content { get; set; }
    public abstract void load () throws Error;
    public abstract Lyric to_lyric ();
}
