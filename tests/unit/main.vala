using Lyrics;

int main (string[] args) {
    Test.init (ref args);

    // Register test cases via Test.add_func & friends
    Test.add_func("/lyrics/lyric", () => {
        Lyric lyric = new Lyric();

        var next_timestamp = lyric.get_next_lyric_timestamp (0);

        if (next_timestamp != null) Test.fail();
    });

    //  Test.add_func ("/lyrics/parsing", () => {
    //  });

    return Test.run ();
}