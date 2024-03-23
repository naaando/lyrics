
public class RepositoryMock : MockClass, IRepository  {
    protected MockMethod find_first_mock { get; set; default = new MockMethod ();}
    protected MockMethod find_mock { get; set; default = new MockMethod ();}

    public ILyricFile? find_first (SongMetadata song) {
        find_first_mock.call ();
        return null;
    }

    public Gee.Collection<ILyricFile>? find (SongMetadata song) {
        find_mock.call ();
        return null;
    }
}
