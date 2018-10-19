
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

    public Player.State state {
        get {
            playing = get_state (player.playback_status == "Playing");
            switch (player.playback_status) {
                case "Playing":
                    return Player.State.PLAYING;
                    break;
                case "Paused":
                    return Player.State.PAUSED;
                    break;
                case "Stopped":
                    return Player.State.STOPPED;
                    break;
                default:
                    return Player.State.UNKNOWN;
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

            var _playing = (player.playback_status != "Stopped");
            if (playing != _playing) {
                playing = _playing;
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

       playing = (player.playback_status == "Playing");
    }

    ~Player () {
        message (@"removing player $busname");
    }

    void toggle () {
        try {
            if(playing) {
                player.play ();
            } else {
                player.pause ();
            }
        } catch (Error e) {
            message (e.message);
        }
    }
}
