using Parser;

public class Unit.Parser.LrcParserTest : Unit.TestCase {
    protected override void setup () {
        //
    }

    protected override void teardown () {
        //
    }

    public LrcParserTest() {
        register ("/test_can_instantiate_parser", test_can_instantiate_parser);
    }

    void test_can_instantiate_parser() {
        var parser = new LrcParser();
        assert (parser != null);
    }
}