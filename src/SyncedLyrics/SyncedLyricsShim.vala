public class SyncedLyricsShim : Object {
    public void install() {
        string stdout = "";
        string stderr = "";
        int status = 0;

        try {

            Process.spawn_command_line_sync (
                @"python3 -m venv $(Application.DEFAULT_LYRICS_DIR)/.venv",
                out stdout,
                out stderr,
                out status
            );

            print (stdout);
            print (stderr);

            Process.spawn_command_line_sync (
                Application.DEFAULT_LYRICS_DIR + ".venv/bin/pip install syncedlyrics",
                out stdout,
                out stderr,
                out status
            );

            print (stdout);
            print (stderr);
        } catch (SpawnError e) {
            critical(e.message);
        }
    }

    public File? search(string search_terms, string filename) {
        string stdout = "";
        string stderr = "";
        int status = 0;

        var app_local_storage = Application.DEFAULT_LYRICS_DIR;
        var path = app_local_storage + filename;

        try {
            Process.spawn_command_line_sync (
                @"$(Application.DEFAULT_LYRICS_DIR).venv/bin/syncedlyrics -o \"$(path)\" \"$(search_terms)\"",
                out stdout,
                out stderr,
                out status
            );

            print (stdout);
            print (stderr);
        } catch (SpawnError e) {
            critical(e.message);
            return null;
        }

        if (status != 0 || stderr.contains("No synced-lyrics found")) {
            debug("Lyric search failed");
            return null;
        }

        return File.new_for_path (path);
    }
}
