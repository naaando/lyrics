public class Parser.LyricEmptyStringParser : ChainOfResponsability {
    public override bool can_parse (string item) {
        return item == "";
    }

    public override void process (Lyrics.Lyric lyric, string ln) {
        return;
    }
}
