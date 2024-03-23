
public class RepositoryMock : MockClass, Lyrics.IRepository  {
    protected MockMethod find_first_mock { get; set; default = new MockMethod ();}
    protected MockMethod find_mock { get; set; default = new MockMethod ();}

    public Lyrics.ILyricFile? find_first (Lyrics.SongMetadata song) {
        find_first_mock.call ();
        return null;
    }

    public Gee.Collection<Lyrics.ILyricFile>? find (Lyrics.SongMetadata song) {
        find_mock.call ();
        return null;
    }
}
