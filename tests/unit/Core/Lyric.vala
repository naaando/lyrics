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
        register ("/test_other_can_instantiate_lyric", test_other_can_instantiate_lyric);
    }

    void test_can_instantiate_lyric() {
        Lyric lyric = new Lyric();

        var next_timestamp = lyric.get_next_lyric_timestamp (0);

        if (next_timestamp != null) Test.fail();
    }

    void test_other_can_instantiate_lyric() {
        Lyric lyric = new Lyric();

        var next_timestamp = lyric.get_next_lyric_timestamp (0);

        if (next_timestamp != null) Test.fail();
    }
}