[DBus (name = "org.lyricsources.LyricSourcePlugin")]
public interface LyricSources.Downloader : Object {
    public abstract string name { owned get; }

    public abstract signal void search_complete (int32 a, int32 b, HashTable<string, Variant>[] result);
    public abstract signal void download_complete (int32 a, int32 b, uint8[] file);

    public abstract int32 search (HashTable<string, Variant> metadata) throws Error;
    public abstract void cancel_search (int32 ticket) throws Error;
    public abstract int32 download (Variant donwloadinfo) throws Error;
    public abstract void cancel_download (int32 ticket) throws Error;
}
