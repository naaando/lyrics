public class Lyrics.PlayerChooser : Gtk.ComboBoxText {
    Players players;

    public PlayerChooser (Players _players) {
        players = _players;

        //  Connecting signals to update callback
        players.on_active_player_changed.connect (() => update_view ());
        players.added.connect (() => update_view ());
        players.removed.connect (() => update_view ());

        this.update_view ();
        changed.connect (set_active_player);
    }

    public void update_view () {
        this.remove_all ();

        foreach (var item in players.get_players ()) {
            this.append (item.busname, item.identity);
        }

        this.set_active_id (players.active_player.busname);
    }

    public void set_active_player () {
        players.set_player_busname_active (this.active_id);
    }
}