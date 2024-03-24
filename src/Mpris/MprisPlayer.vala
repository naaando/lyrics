
public class MprisPlayer : Object, Player {
    Mpris.PlayerIface player;
    Mpris.DbusPropIface prop;

    public int64 position {
        get {
            try {
                return (int64) this.prop.get ("org.mpris.MediaPlayer2.Player", "Position");
            } catch (Error e) {
                return 0;
            }
        }
    }

    public SongMetadata current_song { get;set; }

    private HashTable<string,Variant> metadata  {
        owned get {
            return player.metadata;
        }
    }

    public PlayerState state { get; protected set; default = PlayerState.STOPPED; }
    public string busname { get;protected set; }
    public string? identity { get;protected set; }

    public MprisPlayer (string busname) {
        try {
            player = Bus.get_proxy_sync (BusType.SESSION, busname, "/org/mpris/MediaPlayer2");
            prop = Bus.get_proxy_sync (BusType.SESSION, busname, "/org/mpris/MediaPlayer2");
        } catch (Error e) {
            message (e.message);
        }

        this.busname = busname;
        this.identity = player.identity;

        update_state ();
        update_metadata ();

        prop.properties_changed.connect (() => {
            update_metadata ();
            update_state ();
        });

        player.seeked.connect (() => {
            debug (@"$(player.identity) seeked\n");
            update_metadata ();
            update_state ();
        });
    }

    ~MprisPlayer () {
        message (@"removing player $busname");
    }

    void update_metadata () {
        if (metadata == null) {
            current_song = null;
            return;
        }

        var new_song = new SongMetadata.from_metadata (metadata);

        if (current_song?.to_string () == new_song?.to_string ()) {
            return;
        }

        current_song = new_song;
        debug(current_song?.to_string ());
    }

    void update_state () {
        switch (player.playback_status) {
            case "Playing":
                state = PlayerState.PLAYING;
                break;
            case "Paused":
                state = PlayerState.PAUSED;
                break;
            case "Stopped":
                state = PlayerState.STOPPED;
                break;
            default:
                state = PlayerState.UNKNOWN;
                break;
        }
    }

    public void toggle_play_pause () {
        try {
            if(state != PlayerState.PLAYING) {
                player.play ();
            } else if (state != PlayerState.STOPPED) {
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
