
public class Mpris.Player : Object, Lyrics.Player {
    PlayerIface player;
    DbusPropIface prop;

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

    public Lyrics.Player.State state { get; private set; default = Lyrics.Player.State.STOPPED; }
    public string busname { get;private set; }

    public Player (string busname) {
        try {
            player = Bus.get_proxy_sync (BusType.SESSION, busname, "/org/mpris/MediaPlayer2");
            prop = Bus.get_proxy_sync (BusType.SESSION, busname, "/org/mpris/MediaPlayer2");
        } catch (Error e) {
            message (e.message);
        }

        this.busname = busname;
        update_state ();
        update_metadata ();

        prop.properties_changed.connect (() => {
            update_metadata ();
            update_state ();
        });
    }

    ~Player () {
        message (@"removing player $busname");
    }

    void update_metadata () {
        if (metadata != null) {
            if (current_song != null) {
                if (metadata["xesam:url"] != null && !current_song.compare_uri (metadata["xesam:url"].get_string ())) {
                    current_song = new Lyrics.Metasong.from_metadata (metadata);
                }
            } else if (metadata["xesam:url"] != null) {
                current_song = new Lyrics.Metasong.from_metadata (metadata);
            }
        }
    }

    void update_state () {
        switch (player.playback_status) {
            case "Playing":
                state = Lyrics.Player.State.PLAYING;
                break;
            case "Paused":
                state = Lyrics.Player.State.PAUSED;
                break;
            case "Stopped":
                state = Lyrics.Player.State.STOPPED;
                break;
            default:
                state = Lyrics.Player.State.UNKNOWN;
                break;
        }
    }

    public void toggle_play_pause () {
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

    public void previous () {
        try {
            player.previous ();
        } catch (Error e) {
            warning (e.message);
        }
    }

    public void next () {
        try {
            player.next ();
        } catch (Error e) {
            warning (e.message);
        }
    }
}
