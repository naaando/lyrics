int main (string[] args) {
    Test.init (ref args);

    new Unit.Core.LyricTest();

    return Test.run ();
}