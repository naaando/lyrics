
public interface Lyrics.Player : Object {
    public abstract int64 position { get; }
    public abstract Metasong current_song { get;set; }
    public abstract State state { get; set; }
    public abstract string busname { get; set; }

    public abstract void toggle ();

    public enum State {
        NO_PLAYER,
        NOT_PLAYING,
        PLAYING,
        PAUSED;

        public string to_string () {
            switch (this) {
                case NO_PLAYER:
                    return "NO_PLAYER";

                case NOT_PLAYING:
                    return "NOT_PLAYING";

                case PLAYING:
                    return "PLAYING";

                default:
                    assert_not_reached();
            }
        }
    }
}