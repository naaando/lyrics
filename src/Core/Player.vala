
public interface Lyrics.Player : Object {
    public abstract int64 position { get; }
    public abstract Metasong current_song { get;set; }
    public abstract State state { get; set; }
    public abstract string busname { get; set; }

    public abstract void toggle ();

    public enum State {
        NO_PLAYER,
        UNKNOWN,
        STOPPED,
        PLAYING,
        PAUSED;

        public string to_string () {
            switch (this) {
                case NO_PLAYER:
                    return "NO_PLAYER";
                    break;
                case UNKNOWN:
                    return "UNKNOWN";
                    break;
                case STOPPED:
                    return "STOPPED";
                    break;
                case PAUSED:
                    return "PAUSED";
                    break;
                case PLAYING:
                    return "PLAYING";
                    break;
                default:
                    assert_not_reached();
                    break;
            }
        }
    }
}
