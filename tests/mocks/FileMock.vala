public class FileMock : MockClass, ILyricFile {
    public string? get_metadata (string attribute_name) {
        assert_not_reached ();
    }

    public string get_content () {
        assert_not_reached ();
    }

    public Lyric to_lyric () {
        assert_not_reached ();
    }
}
