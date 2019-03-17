
public class Remote.RemoteFile : Lyrics.ILyricFile, Object {
    public Gee.HashMap<string, string> metadata = new Gee.HashMap<string, string> (null, null);
    string? content;
    ViewlyricsRepository repository;

    public RemoteFile.from_xmlbird_attributes (ViewlyricsRepository repo, B.Attributes attributes) {
        repository = repo;

        foreach (var attribute in attributes) {
            metadata[attribute.get_name ()] = attribute.get_content ();
        }
    }

    public void load () {
        content = repository.download_lyric (metadata["link"]);
    }

    public string? get_metadata (string attribute) {
        return metadata[attribute];
    }

    public string get_content () {
        if (content == null) {
            load ();
        }

        return content;
    }

    public Lyrics.Lyric to_lyric () {
        var lrc = new Parser.LRC ().parse_string (content);
        return lrc;
    }

    public string to_string () {
        var string_builder = new StringBuilder ();
        string_builder.append (@"Metadata:\n");
        metadata.@foreach ((entry) => {
            string_builder.append (@"$(entry.key) => $(entry.value)\n");
            return false;
        });

        string_builder.append (@"Content:\n");
        string_builder.append (@"$(get_content ())\n");

        return string_builder.str;
    }
}
