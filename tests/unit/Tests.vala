class UnitTest {
    public static int main (string[] args) {
        Test.init (ref args);
        // Register test cases via Test.add_func & friends
        assert (true == true);

        return Test.run ();
    }
}