public interface Lyrics.IRepository : Object {
    public abstract ILyricFile? find_first (Metasong song);
    public abstract Gee.Collection<ILyricFile>? find (Metasong song);
}
