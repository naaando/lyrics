using Parser;
using Lyrics;

public class Unit.Parser.LrcParserTest : Unit.TestCase {
    protected override void setup () {
        //
    }

    protected override void teardown () {
        //
    }

    public LrcParserTest() {
        register ("/test_can_instantiate_parser", test_can_instantiate_parser);
        register ("/test_can_parse_empty_lrc_file", test_can_parse_empty_lrc_file);
        register ("/test_can_parse_lrc_file", test_can_parse_lrc_file);
        register ("/test_can_parse_lrc_file_without_line_endings", test_can_parse_lrc_file_without_line_endings);
    }

    void test_can_instantiate_parser() {
        var parser = new LrcParser();
        assert (parser != null);
    }

    void test_can_parse_empty_lrc_file() {
        GLib.FileIOStream iostream = null;
        Lyric? lrc = null;
        GLib.File file = null;

        try {
            file = GLib.File.new_tmp ("test-XXXXXX.lrc", out iostream);
        } catch (GLib.Error e) {
            Test.fail ();
            GLib.warning ("Erro de E/S: %s", e.message);
            return;
        }

        string data = "";

        try {
            iostream.output_stream.write (data.data);
        } catch (GLib.IOError e) {
            Test.fail ();
            GLib.warning ("Erro de E/S: %s", e.message);
            return;
        }

        var parser = new LrcParser();
        lrc = parser.parse_file (file);
        assert_nonnull (lrc);

        assert_cmpint (
            lrc.size,
            GLib.CompareOperator.EQ,
            0
        );

        assert_null(lrc.get_current_line (0));
    }

    void test_can_parse_lrc_file() {
        GLib.FileIOStream iostream = null;
        Lyric? lrc = null;

        try {
            var file = GLib.File.new_tmp ("test-XXXXXX.lrc", out iostream);

            string data = """
[00:23.50]Verse 1
[00:25.00]I'm reaching out for you
[00:28.20]But you're not reaching back
[00:32.00]I'm shouting out your name
[00:35.80]But silence is all I hear

[01:10.50]Chorus
[01:12.00]You were my guiding light
[01:15.30]But now you're out of sight
[01:19.00]I'm lost in this endless night
[01:23.00]Hoping for a glimpse of your light

[02:05.20]Verse 2
[02:07.00]The memories linger on
[02:10.50]Of moments that we shared
[02:14.80]But now it's just a void
[02:18.50]A hollow space I can't repair
""";

            iostream.output_stream.write (data.data);

            var parser = new LrcParser();
            lrc = parser.parse_file (file);
            assert_nonnull (lrc);
        } catch (GLib.Error e) {
            Test.fail ();
            GLib.warning ("Erro de E/S: %s", e.message);
        }

        // assert size of lyric
        assert_cmpint (
            lrc.size,
            GLib.CompareOperator.EQ,
            15
        );

        var one_minute_in_us = 60 * 1000 * 1000;

        //  can get expected line
        assert_cmpstr (
            lrc.get_current_line (one_minute_in_us),
            GLib.CompareOperator.EQ,
            "Chorus"
        );

        assert_cmpstr (
            lrc.get_current_line (2 * one_minute_in_us),
            GLib.CompareOperator.EQ,
            "Verse 2"
        );
    }

    void test_can_parse_lrc_file_without_line_endings() {
        GLib.FileIOStream iostream = null;
        Lyric? lrc = null;

        try {
            var file = GLib.File.new_tmp ("test-XXXXXX.lrc", out iostream);

            string data = "[00:23.50]Verse 1[00:25.00]I'm reaching out for you[00:28.20]But you're not reaching back[00:32.00]I'm shouting out your name[00:35.80]But silence is all I hear[01:10.50]Chorus[01:12.00]You were my guiding light[01:15.30]But now you're out of sight[01:19.00]I'm lost in this endless night[01:23.00]Hoping for a glimpse of your light[02:05.20]Verse 2[02:07.00]The memories linger on[02:10.50]Of moments that we shared[02:14.80]But now it's just a void[02:18.50]A hollow space I can't repair";

            iostream.output_stream.write (data.data);

            var parser = new LrcParser();
            lrc = parser.parse_file (file);
            assert_nonnull (lrc);
        } catch (GLib.Error e) {
            Test.fail ();
            GLib.warning ("Erro de E/S: %s", e.message);
        }

        // assert size of lyric
        assert_cmpint (
            lrc.size,
            GLib.CompareOperator.EQ,
            15
        );

        var one_minute_in_us = 60 * 1000 * 1000;

        //  can get expected line
        assert_cmpstr (
            lrc.get_current_line (one_minute_in_us),
            GLib.CompareOperator.EQ,
            "Chorus"
        );

        assert_cmpstr (
            lrc.get_current_line (2 * one_minute_in_us),
            GLib.CompareOperator.EQ,
            "Verse 2"
        );
    }
}