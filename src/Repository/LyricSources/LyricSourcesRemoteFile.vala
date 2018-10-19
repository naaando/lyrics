
public class LyricsSources.RemoteFile : Lyrics.ILyricFile, Object {
    HashTable<string, Variant> metadata;
    LyricSources.Downloader downloader;
    public string content { get; set; }

    public RemoteFile (LyricSources.Downloader downloader, HashTable<string, Variant> metadata) {
        this.metadata = metadata;
        this.downloader = downloader;
    }

    public void load () {
        var loop = new MainLoop ();

        var ticket = downloader.download (metadata["downloadinfo"]);
        downloader.download_complete.connect ((id, b, file) => {
            print (@"ID $id Another int $b \n");
            if (id == ticket) {
                content = (string) file;
                loop.quit ();
            }
        });

        loop.run ();
    }

    public Lyrics.Lyric to_lyric () {
        if (content == null) {
            load ();
        }

        print (@"Content:\n");
        print (@"$content\n");
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
        string_builder.append (@"$content\n");

        return string_builder.str;
    }
}
