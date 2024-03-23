
public class Lyrics.Factory.SongMetadataFactory : Object {
    public static SongMetadata get_unknow_SongMetadata () {
        var SongMetadata = new SongMetadata ();
        SongMetadata.artist = "Unknow artist";
        SongMetadata.title = "Unknow title";
        SongMetadata.genre = "Unknow genre";
        SongMetadata.album = "Unknow album";
        SongMetadata.duration = 4*(60*1000000000); //  4 minutes = 4*60*10^9 (nanoseconds)
        //  SongMetadata.uri = ;
        //  SongMetadata.path = ;
        //  SongMetadata.filename = ;
        //  SongMetadata.thumb = ;
        return SongMetadata;
    }
}
