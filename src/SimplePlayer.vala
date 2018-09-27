
public class SimplePlayer : Object, Lyrics.Player {
    public int64 position {
        get {
            return 0;
        }
    }
    public Lyrics.Metasong current_song { get;set; }
    public HashTable<string,Variant> metadata  { owned get; }
    public bool playing { get; set; }
    public string busname { get; private set; }

    //  private timer;

    public SimplePlayer (string bn, Lyrics.Metasong music) {
        busname = bn;
        current_song = music;
    }

    public void toggle () {
        playing = !playing;
    }
}