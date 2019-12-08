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
        this.visible = players.get_players ().length >= 2;
        if (!this.visible) return;

        foreach (var item in players.get_players ()) {
            this.append (item.busname, item.identity);
        }

        this.set_active_id (players.active_player.busname);
    }

    public void set_active_player () {
        bool id_changed = players.active_player.busname != this.active_id;

        if (this.active_id != null && id_changed) {
            message ("Changing current player.");
            players.set_player_busname_active (this.active_id);
        }
    }

    /**
     * Override show () method to avoid show_all () toggling
     * visibility when less than two players has been found
     */
    public override void show () {
        if (players.get_players ().length < 2) {
            this.visible = false;
            return;
        }

        base.show ();
    }
}