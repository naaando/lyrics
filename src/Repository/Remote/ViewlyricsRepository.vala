public class Remote.ViewlyricsRepository : Lyrics.IRepository, Object {
    Soup.Session session = new Soup.SessionAsync ();

    const string search_url = "http://search.crintsoft.com/searchlyrics.htm";
    const string download_url = "http://viewlyrics.com/";
    const string VIEWLYRICS_KEY = "Mlv1clt4.0";
    const string VIEWLYRICS_AGENT = "OSD Lyrics";
    const string VIEWLYRICS_QUERY_FORM = "<?xml version=\'1.0\' encoding=\'utf-8\' ?><searchV1 %s />";

    public Lyrics.ILyricFile? find_first (Lyrics.Metasong song) {
        var res = find (song);
        if (res != null && !res.is_empty) {
            return (res as Gee.List<Lyrics.ILyricFile>).first ();
        }

        return null;
    }

    public Gee.Collection<Lyrics.ILyricFile>? find (Lyrics.Metasong song) {
        string response = search (song);
        var files_array = build_file_list (response);

        var files = new Gee.ArrayList<Lyrics.ILyricFile> ();
        files.add_all_array (files_array);

        return files;
    }

    public ViewlyricsRepository () {
        session.user_agent = VIEWLYRICS_AGENT;
    }

    public string download_lyric (string lrc_location) {
        string lyric_url = download_url + lrc_location;
        var msg = new Soup.Message ("GET", lyric_url);

        var loop = new MainLoop ();
        string result = "";

        session.queue_message (msg, (sess, mess) => {
            result = (string) mess.response_body.data;
            loop.quit ();
        });

        loop.run ();
        return result;
    }

    string search (Lyrics.Metasong song) {
        var query = mount_query (song);
        var msg = new Soup.Message ("POST", search_url);
        msg.request_headers.append ("Accept", "*/*");
        msg.set_request (Soup.FORM_MIME_TYPE_URLENCODED, Soup.MemoryUse.COPY, encode_query (query));

        var loop = new MainLoop ();

        string response = "";
        session.queue_message (msg, (sess, mess) => {
            response = decode_response (mess.response_body.data);
            loop.quit ();
        });

        loop.run ();

        return response;
    }

    Lyrics.ILyricFile[] build_file_list (string response) {
        Lyrics.ILyricFile[] files = {};

        var parser = new B.XmlParser (response);
        var root = parser.get_root_tag ();
        foreach (var tag in root) {
            var attributes = tag.get_attributes ();

            if (link_points_to_lrc (attributes)) {
                files += new RemoteFile.from_xmlbird_attributes (this, attributes);
            }
        }

        return files;
    }

    bool link_points_to_lrc (B.Attributes attributes) {
        bool is_lrc = false;

        foreach (var attribute in attributes) {
            if (attribute.get_name () == "link") {
                is_lrc = attribute.get_content ().contains (".lrc");
            }
        }

        return is_lrc;
    }

    static string mount_query (Lyrics.Metasong song) {
        var builder = new StringBuilder ();
        string tmpl = "%s=\"%s\" ";
        builder.append (tmpl.printf ("artist", song.artist));
        builder.append (tmpl.printf ("title", song.title));
        builder.append (tmpl.printf ("client", "MiniLyrics"));

        return VIEWLYRICS_QUERY_FORM.printf (builder.str);
    }

    string decode_response (uint8[] response_data) {
        uint8[] reassembled_string = {};
        var code_key = response_data[1];

        foreach (var character in response_data[22:response_data.length]) {
            char decoded_char = (char) (character ^ code_key);
            reassembled_string += decoded_char;
        }

        return (string) reassembled_string;
    }

    uint8[] encode_query (string query) {
        uint8[] payload = { 0x02, 0x00, 0x04, 0x00, 0x00, 0x00 };

        foreach (var byte in compute_message_hash (VIEWLYRICS_KEY, query)) {
            payload += byte;
        }

        //  Append query bytes
        foreach (var byte in query.data) {
            payload += byte;
        }

        return payload;
    }

    static uint8[] compute_message_hash (string key, string query) {
        var message = new Checksum (ChecksumType.MD5);
        message.update (query.data, query.data.length);
        message.update (key.data, key.data.length);

        uint8[] buffer = new uint8[1500];
        size_t digest_len = -1;
        message.get_digest (buffer, ref digest_len);
        buffer.resize ((int) digest_len);

        return buffer;
    }
}
