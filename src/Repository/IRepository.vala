public interface IRepository : Object {
    public abstract ILyricFile? find_first (SongMetadata song);
    public abstract Gee.Collection<ILyricFile>? find (SongMetadata song);
}
