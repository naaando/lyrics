public interface Lyrics.IRepository : Object {
    public abstract Gee.Collection<ILyricFile> find (Metasong song);
}
