public interface Lyrics.ILyricFile : Object {
    public abstract void load () throws Error;
    public abstract bool save () throws Error;
    public abstract Lyric to_lyric ();
}
