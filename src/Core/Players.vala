
public class Lyrics.Players : Object {
    private Mpris.Service scanner;

    public signal void added (Player player);
    public signal void removed (Player player);
    public signal void on_active_player_changed (Player player);

    Player _active_player;
    public Player? active_player {
        get {
            return _active_player;
        }
        set {
            _active_player = value;
            _active_player.notify.connect (() => {
                if (value == _active_player) {
                    on_active_player_changed (_active_player);
                }
            });
        }
    }

    Gee.ArrayList<Player> players = new Gee.ArrayList<Player> ();

    public Players () {
        added.connect ((player) => {
            if (active_player == null) {
                active_player = player;
            }
        });

        removed.connect ((player) => {
            if (active_player == player) {
                active_player = !players.is_empty ? players.first () : null;
            }
        });

        scanner = new Mpris.Service ();

        scanner.found.connect ((player) => add (player));
        scanner.lost.connect (remove_by_busname);
        scanner.setup_dbus ();

        notify["active-player"].connect (() => on_active_player_changed (active_player));
        notify["active-player"].connect (() => on_active_player_changed (active_player));

    }

    public bool add (Player player) {
        if (players.add (player)) {
            added (player);
            return true;
        }

        return false;
    }

    public bool remove (Player player) {
        if (players.remove (player)) {
            removed (player);
            return true;
        }

        return false;
    }

    public void remove_by_busname (string name) {
        var player_to_remove = players.first_match ((player) => player.busname == name);
        if (player_to_remove != null) {
            remove (player_to_remove);
        }
    }

    public Player[] get_players () {
        return players.to_array();
    }

    public bool set_player_busname_active (string busname) {
        var new_active = players.first_match ((player) => player.busname == busname);

        if (new_active == null) return false;

        this.active_player = new_active;
        return true;
    }
}
