
public class PlayerMock : MockClass, Lyrics.Player  {
    public int64 position { get; }
    public Lyrics.Metasong current_song { get; set; }
    public Lyrics.Player.State state { get; protected set; }
    public string busname { get; protected set; }
    public string? identity { get; protected set; }

    public void toggle_play_pause () {
        assert_not_reached ();
    }

    public void previous () {
        assert_not_reached ();
    }

    public void next () {
        assert_not_reached ();
    }

}
