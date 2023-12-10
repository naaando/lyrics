using Lyrics;

public class Unit.Core.LyricsServiceTest : Unit.TestCase {
    protected override void setup () {
        //
    }

    protected override void teardown () {
        //
    }

    public LyricsServiceTest() {
        register ("/test_can_instantiate_lyrics_service", test_can_instantiate_lyrics_service);
        register ("/test_set_player_null_song", test_set_player_null_song);
        register ("/test_set_player_with_song", test_set_player_with_song);
    }

    void test_can_instantiate_lyrics_service() {
        var mock_repository = new RepositoryMock ();
        var lyrics_service = new LyricsService(mock_repository);

        assert_cmpstr (
            lyrics_service.state.to_string (),
            GLib.CompareOperator.EQ,
            LyricsService.State.UNKNOWN.to_string ()
        );
    }

    void test_set_player_null_song() {
        var player = new PlayerMock ();
        var mock_repository = new RepositoryMock ();
        var lyrics_service = new LyricsService(mock_repository);

        lyrics_service.set_player (player);

        assert_cmpstr (
            lyrics_service.state.to_string (),
            GLib.CompareOperator.EQ,
            LyricsService.State.UNKNOWN.to_string ()
        );
    }

    void test_set_player_with_song() {
        var song = new Metasong ();
        var player = new PlayerMock ();
        var mock_repository = new RepositoryMock ();
        var lyrics_service = new LyricsService(mock_repository);

        mock_repository
            .should_call ("find_first")
            .never ();

        player.current_song = song;

        LyricsService.State[] state_change = {
            LyricsService.State.DOWNLOADING,
            LyricsService.State.LYRICS_NOT_FOUND,
        };

        uint state_changed_count = 0;

        lyrics_service.notify["state"].connect ((sender, state) => {
            assert_cmpstr (
                lyrics_service.state.to_string (),
                GLib.CompareOperator.EQ,
                state_change[state_changed_count].to_string ()
            );

            state_changed_count = state_changed_count + 1;
        });

        lyrics_service.set_player (player);

        while (lyrics_service.state != LyricsService.State.LYRICS_NOT_FOUND) {
            //  wait for the state to change
        }

        assert_cmpuint(state_changed_count, GLib.CompareOperator.EQ, 2);
    }
}
