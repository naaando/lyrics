public enum LyricsServiceState {
    UNKNOWN,
    DOWNLOADING,
    LYRICS_NOT_FOUND,
    DOWNLOADED;

    public string to_string () {
        switch (this) {
            case UNKNOWN:
                return "UNKNOWN";
            case DOWNLOADING:
                return "DOWNLOADING";
            case LYRICS_NOT_FOUND:
                return "LYRICS NOT FOUND";
            case DOWNLOADED:
                return "DOWNLOADED";
            default:
                assert_not_reached();
        }
    }
}

public class LyricsService : Object {
    public LyricsServiceState state { get; set; }
    IRepository lyric_repository;
    public Lyric? lyric  { get; set; }
    GLib.MainLoop? request_event_loop;
    SongMetadata song;

    public LyricsService (IRepository repository) {
        lyric_repository = repository;
        state = LyricsServiceState.UNKNOWN;
    }

    public void set_player (Player player) {
        debug (player.busname);
        debug (player.current_song?.to_string ());

        if (player.current_song.equals(song)) {
            return;
        }

        if (request_event_loop != null && request_event_loop.is_running ()) {
            request_event_loop.quit ();
        }

        request_event_loop = new GLib.MainLoop ();

        if (player.current_song == null) {
            state = LyricsServiceState.UNKNOWN;
            return;
        }

        request_lyric.begin (player.current_song, () => {
            request_event_loop.quit ();
        });

        request_event_loop.run ();
    }

    public signal void set_lyric (Lyric lyric) {
        this.lyric = lyric;
        state = LyricsServiceState.DOWNLOADED;
    }

    private async void request_lyric (SongMetadata song) {
        state = LyricsServiceState.DOWNLOADING;

        var lyricfile = lyric_repository.find_first (song);

        if (lyricfile != null) {
            lyric = lyricfile.to_lyric ();
            state = LyricsServiceState.DOWNLOADED;
            return;
        }

        state = LyricsServiceState.LYRICS_NOT_FOUND;

        lyric = null;
    }
}
