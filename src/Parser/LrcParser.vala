
public class Parser.LrcParser : Object {
    private Lyrics.Lyric lyric;
    ChainOfResponsability parse_chain;

    public LrcParser () {
        parse_chain = new LyricEmptyStringParser ();
        parse_chain.add_parser_to_chain (new LyricMetadataParser ());
        parse_chain.add_parser_to_chain (new CompressedLyricContentParser ());
        parse_chain.add_parser_to_chain (new LyricContentParser ());
    }

    public Lyrics.Lyric? parse (File file) {
        //  gerando erro
        //  #1  <unknown>   in 'g_object_ref'
        //      at /lib/x86_64-linux-gnu/libgobject-2.0.so.0
        //  #2  <unknown>   in 'lyrics_lyric_construct'
        //      at com.github.naaando.lyrics
        //  #3  <unknown>   in 'lyrics_lyric_new'
        //      at com.github.naaando.lyrics
        //  #4  <unknown>   in 'parser_lrc_parse'
        //      at com.github.naaando.lyrics
        //  #5  <unknown>   in 'lyrics_ilyric_file_to_lyric'
        //      at com.github.naaando.lyrics
        //  #6  <unknown>   in 'lyrics_lyrics_service_request_lyric'
        //      at com.github.naaando.lyrics
        //  #7  <unknown>   in 'lyrics_idisplay_set_player'
        //      at com.github.naaando.lyrics
        lyric = new Lyrics.Lyric ();

        try {
            DataInputStream dis = new DataInputStream (file.read ());
            string ln;
            size_t length;

            while ((ln = dis.read_upto ("[", 0, out length)) != null) {
                debug ("Parsing line: " + ln);
                parse_chain.parse (lyric, "[" + ln.strip ());
                dis.read_byte ();
            }
        } catch (Error e) {
            warning (e.message);
            lyric = null;
        }

        return lyric;
    }

    public Lyrics.Lyric parse_string (string lrc) {
        lyric = new Lyrics.Lyric ();

        foreach (var ln in lrc.split ("\n")) {
            parse_chain.parse (lyric, ln.strip ());
        }

        return lyric;
    }
}
