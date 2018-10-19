
public class Mpris.Player : Mpris.Client, Lyrics.Player {
    public int64 position {
        get {
            try {
                return (int64) this.prop.get ("org.mpris.MediaPlayer2.Player", "Position");
            } catch (Error e) {
                return 0;
            }
        }
    }

    public Lyrics.Metasong current_song { get;set; }

    private HashTable<string,Variant> metadata  {
        owned get {
            return player.metadata;
        }
    }

    public Lyrics.Player.State state {
        get {
            switch (player.playback_status) {
                case "Playing":
                    return Lyrics.Player.State.PLAYING;
                case "Paused":
                    return Lyrics.Player.State.PAUSED;
                case "Stopped":
                    return Lyrics.Player.State.STOPPED;
                default:
                    return Lyrics.Player.State.UNKNOWN;
            }
        }

        set {
            switch (value) {
                case Lyrics.Player.State.PLAYING:
                    try {
                        player.play ();
                    } catch (Error e) { warning (e.message); }
                    break;
                case Lyrics.Player.State.PAUSED:
                    try {
                        player.pause ();
                    } catch (Error e) { warning (e.message); }
                    break;
                case Lyrics.Player.State.STOPPED:
                    try {
                        player.stop ();
                    } catch (Error e) { warning (e.message); }
                    break;
            }
        }
    }

    public string busname { get;private set; }

    public Player (string busname) {
        try {
            // Call base class constructor
            base (Bus.get_proxy_sync(BusType.SESSION, busname, "/org/mpris/MediaPlayer2"), Bus.get_proxy_sync(BusType.SESSION, busname, "/org/mpris/MediaPlayer2"));
        } catch (Error e) {
            message (e.message);
        }

        this.busname = busname;

        Timeout.add (250, () => {
            if (metadata == null) {
                return false;
            }

            if (current_song != null) {
                if (metadata["xesam:url"] != null && !current_song.compare_uri (metadata["xesam:url"].get_string ())) {
                    current_song = new Lyrics.Metasong.from_metadata (metadata);
                }
            } else if (metadata["xesam:url"] != null) {
                current_song = new Lyrics.Metasong.from_metadata (metadata);
            }

            return true;
        });

    }

    ~Player () {
        message (@"removing player $busname");
    }

    void toggle () {
        try {
            if(state != Lyrics.Player.State.PLAYING) {
                player.play ();
            } else if (state != Lyrics.Player.State.STOPPED) {
                player.pause ();
            }
        } catch (Error e) {
            message (e.message);
        }
    }
}
