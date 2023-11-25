public class SyncedLyrics.Shim : Object {
    public void install() {
        string stdout = "";
        string stderr = "";
        int status = 0;

        Process.spawn_command_line_sync (
            @"python3 -m venv $(Lyrics.Application.DEFAULT_LYRICS_DIR)/.venv",
            out stdout,
            out stderr,
            out status
        );

        print (stdout);
        print (stderr);

        Process.spawn_command_line_sync (
            Lyrics.Application.DEFAULT_LYRICS_DIR + ".venv/bin/pip install syncedlyrics",
            out stdout,
            out stderr,
            out status
        );

        print (stdout);
        print (stderr);
    }

    public File? search(string artist, string title) {
        string stdout = "";
        string stderr = "";
        int status = 0;

        var app_local_storage = Lyrics.Application.DEFAULT_LYRICS_DIR;
        var path = app_local_storage + title + " - " + artist + ".lrc";

        Process.spawn_command_line_sync (
            //  @"Finished saving file to $(file.get_path ())"
            @"$(Lyrics.Application.DEFAULT_LYRICS_DIR).venv/bin/syncedlyrics -o \"$(path)\" \"$(title) - $(artist)\"",
            out stdout,
            out stderr,
            out status
        );

        print (stdout);
        print (stderr);

        if (status != 0) {
            return null;
        }

        return File.new_for_path (path);
    }
}