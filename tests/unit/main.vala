int main (string[] args) {
    Test.init (ref args);

    new Unit.Core.LyricTest();
    new Unit.Parser.LrcParserTest ();

    return Test.run ();
}
