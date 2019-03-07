public class Lyrics.LyricsService : Object {
    public State state { get; set; }
    IRepository lyric_repository = new Repository ();

    public virtual signal void push_lyric (Lyric lyric) {
        state = State.DOWNLOADED;
    }

    public Lyric? request_lyric (Metasong song) {
        state = State.DOWNLOADING;

        var lyricfile = lyric_repository.find_first (song);
        if (lyricfile != null) {
            state = State.DOWNLOADED;

            var lyric = lyricfile.to_lyric ();
            //  Emit a signal notifying that a new lyric arrived
            push_lyric (lyric);
            return lyric;
        }

        state = State.LYRICS_NOT_FOUND;
        return  null;
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
}
