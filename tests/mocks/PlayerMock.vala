
public class PlayerMock : MockClass, Player  {
    public int64 position { get; }
    public SongMetadata current_song { get; set; }
    public Player.State state { get; protected set; }
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
