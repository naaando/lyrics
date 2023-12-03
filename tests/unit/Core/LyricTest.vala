using Lyrics;

public class Unit.Core.LyricTest : Unit.TestCase {
    protected override void setup () {
        //
    }

    protected override void teardown () {
        //
    }

    public LyricTest() {
        register ("/test_can_instantiate_lyric", test_can_instantiate_lyric);
        register ("/test_can_add_line", test_can_add_line);
        register ("/test_can_add_metadata", test_can_add_metadata);
        register ("/test_offset_changes_timestamps", test_offset_changes_timestamps);
    }

    void test_can_instantiate_lyric() {
        Lyric lyric = new Lyric();

        var next_timestamp = lyric.get_next_lyric_timestamp (0);

        if (next_timestamp != null) Test.fail();
    }

    void test_can_add_line() {
        Lyric lyric = new Lyric();

        lyric.add_line (0, "Hello World");

        var next_timestamp = lyric.get_next_lyric_timestamp (0);

        if (next_timestamp != 0) Test.fail();
        if (lyric.get_current_line(0) != "Hello World") Test.fail();
    }

    void test_can_add_metadata() {
        Lyric lyric = new Lyric();

        lyric.add_metadata ("title", "Hello World");
        if (lyric.get_metadata("title") != "Hello World") Test.fail();
    }

    void test_offset_changes_timestamps() {
        Test.skip("Offset is broken");
        return;

        Lyric lyric = new Lyric();
        lyric.add_line (0, "Hello");
        lyric.add_line (500, "World");
        if (lyric.get_current_line (0) != "Hello") Test.fail();
        if (lyric.get_current_line (500) != "World") Test.fail();

        Lyric lyric_offsetted = new Lyric();
        lyric_offsetted.add_metadata("offset", "500");
        lyric_offsetted.add_line (0, "Hello");
        lyric_offsetted.add_line (500, "World");
        if (lyric_offsetted.get_current_line (500) != "Hello") Test.fail();
        if (lyric_offsetted.get_current_line (1000) != "World") Test.fail();
    }
}