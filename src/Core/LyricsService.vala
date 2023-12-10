public class Lyrics.LyricsService : Object {
    public State state { get; set; }
    IRepository lyric_repository;
    public Lyric? lyric  { get; set; }

    public LyricsService (IRepository repository) {
        lyric_repository = repository;
        state = State.UNKNOWN;
    }

    public void set_player (Player player) {
        GLib.MainLoop loop = new GLib.MainLoop ();

        if (player.current_song == null) {
            state = State.UNKNOWN;
            return;
        }

        request_lyric.begin (player.current_song, () => {
            loop.quit ();
        });
        loop.run ();
    }

    public signal void set_lyric (Lyric lyric) {
        this.lyric = lyric;
        state = State.DOWNLOADED;
    }

    public enum State {
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

    private async void request_lyric (Metasong song) {
        state = State.DOWNLOADING;

        var lyricfile = lyric_repository.find_first (song);

        if (lyricfile != null) {
            lyric = lyricfile.to_lyric ();
            state = State.DOWNLOADED;
            return;
        }

        state = State.LYRICS_NOT_FOUND;

        lyric = null;
    }
}
