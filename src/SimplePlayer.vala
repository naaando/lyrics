
public class SimplePlayer : Object, Player {
    public int64 position {
        get {
            return 0;
        }
    }
    public SongMetadata current_song { get;set; }
    public HashTable<string,Variant> metadata  { owned get; }
    public Player.State state { get; set; }
    public string busname { get; protected set; }
    public string? identity { get; protected set; default = "Simple player"; }

    //  private timer;

    public SimplePlayer (string bn, SongMetadata music) {
        busname = bn;
        current_song = music;
    }

    public void toggle_play_pause () {
        if (state != Player.State.STOPPED) {
            state = (state == Player.State.PLAYING) ? Player.State.PAUSED : Player.State.PLAYING;
        }
    }

    public void previous () {
        return;
    }

    public void next () {
        return;
    }
}
