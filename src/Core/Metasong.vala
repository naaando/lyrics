
public class Lyrics.Metasong : Object {
    public string artist { get; set; }
    public string title { get; set; }
    public string genre { get; set; }
    public string album { get; set; }
    public int64 duration { get; set; }
    public string uri  { get; set; }
    public string? path  { get; set; }
    public string filename  { get; set; }
    public string thumb  { get; set; }

    public Metasong.from_metadata (HashTable<string,Variant> metadata) {
        artist = string.joinv (", ", metadata["xesam:artist"].get_strv ());
        if (metadata["xesam:title"] != null) {
            title = metadata["xesam:title"].get_string ();
        }
        if (metadata["xesam:genre"] != null) {
            genre = string.joinv (", ", metadata["xesam:genre"].get_strv ());
        }
        if (metadata["xesam:album"] != null) {
            album = metadata["xesam:album"].get_string ();
        }
        if (metadata["mpris:length"] != null) {
            duration = metadata["mpris:length"].get_int64 ();
        }
        if (metadata["xesam:url"] != null) {
            uri = metadata["xesam:url"].get_string ();
        }
        var file = File.parse_name (uri);
        path = file.get_path ();
        filename = file.get_basename ();

        if (metadata.contains("mpris:artUrl")) {
            thumb = File.parse_name (metadata["mpris:artUrl"].get_string ()).get_path ();
        }
    }

    public bool compare_uri (string uri2) {
        return uri == uri2;
    }

    public string to_string () {
        var builder = new StringBuilder ();
        builder.append (@"Artist: $artist\n");
        builder.append (@"Title: $title\n");
        builder.append (@"Album: $album\n");
        builder.append (@"Duration: $duration\n");
        builder.append (@"URI: $uri\n");
        if (path != null) builder.append (@"Path: $path\n");
        builder.append (@"Filename: $filename\n");
        return builder.str;
    }
}
