
public class LyricsSources.RemoteFile : Lyrics.ILyricFile, Object {
    public HashTable<string, Variant> metadata { get; set; }
    LyricSources.Downloader downloader;
    string content;

    public RemoteFile (LyricSources.Downloader downloader, HashTable<string, Variant> metadata) {
        this.metadata = metadata;
        this.downloader = downloader;
    }

    public void load () {
        var loop = new MainLoop ();

        try {
            var ticket = downloader.download (metadata["downloadinfo"]);
            downloader.download_complete.connect ((id, b, file) => {
                print (@"ID $id Another int $b \n");
                if (id == ticket) {
                    content = (string) file;
                    loop.quit ();
                }
            });
        } catch (Error e) {
            loop.quit ();
            warning (e.message);
        }

        loop.run ();
    }

    public string? get_metadata (string attribute) {
        return metadata[attribute].get_string ();
    }

    public string get_content () {
        if (content == null) {
            load ();
        }

        return content;
    }

    public Lyrics.Lyric to_lyric () {
        print (@"Content:\n");
        print (@"$(get_content ())\n");
        var lrc = new Parser.LRC ().parse_string (content);
        return lrc;
    }

    public string to_string () {
        var string_builder = new StringBuilder ();
        string_builder.append (@"Metadata:\n");
        metadata.@foreach ((k, v) => {
            string_builder.append (@"$k => $(v.print (true))\n");
        });
        string_builder.append (@"Content:\n");
        string_builder.append (@"$(get_content ())\n");

        return string_builder.str;
    }
}
