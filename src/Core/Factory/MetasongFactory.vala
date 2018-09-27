
public class Lyrics.Factory.MetasongFactory : Object {
    public static Metasong get_unknow_metasong () {
        var metasong = new Metasong ();
        metasong.artist = "Unknow artist";
        metasong.title = "Unknow title";
        metasong.genre = "Unknow genre";
        metasong.album = "Unknow album";
        metasong.duration = 4*(60*1000000000); //  4 minutes = 4*60*10^9 (nanoseconds)
        //  metasong.uri = ;
        //  metasong.path = ;
        //  metasong.filename = ;
        //  metasong.thumb = ;
        return metasong;
    }
}