public class Lyrics.Controller.DisplayController : Object {
    const uint64 one_second_to_nanoseconds = 1000000;
    const int one_second_to_milliseconds = 1000;

    Cancellable cancellable;
    IRepository lyric_repository = new Repository ();

    public bool start (Display display, Player player) {
        stop ();

        var lrc = get_lyric (player.current_song);
        if (lrc != null) {
            cancellable = play (lrc, player.position, display);
            return true;
        } else {
            return false;
        }
    }

    public void stop () {
        if (cancellable != null) {
            cancellable.cancel ();
        }
    }

    Cancellable play (Lyric lrc, uint64 position, Display display) {
        uint64 elapsed_time = position;
        var cancellable = new Cancellable ();

        Timeout.add (one_second_to_milliseconds, () => {
            if (cancellable == null || cancellable.is_cancelled ()) {
                return false;
            }

            elapsed_time += one_second_to_nanoseconds;
            display.current_line = lrc.get_current_line (elapsed_time);
            return true;
        });

        return cancellable;
    }

    Lyric? get_lyric (Metasong song) {
        var lyricfile = lyric_repository.find_first (song);
        return lyricfile != null ? lyricfile.to_lyric () : null;
    }
}
