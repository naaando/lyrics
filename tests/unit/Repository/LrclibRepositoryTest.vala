using Lyrics;

public class Unit.Repository.LrclibRepositoryTest : Unit.TestCase {
    protected override void setup () {
        //
    }

    protected override void teardown () {
        //
    }

    public LrclibRepositoryTest() {
        register ("/test_can_instantiate_repository", test_can_instantiate_repository);
        register ("/test_can_use_find", test_can_use_find);
    }

    public void test_can_instantiate_repository () {
        var repository = new LrclibRepository ();
        assert (repository != null);
    }

    public void test_can_use_find () {
        var song = new SongMetadata ();
        song.title = "title_test";
        song.artist = "artist_test";
        song.album = "album_test";
        song.duration = 1000;

        var repository = new LrclibRepository ();
        var result = repository.find (song);
        assert (result != null);
    }
}
