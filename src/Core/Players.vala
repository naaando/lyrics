
public class Lyrics.Players : Object {
    public signal void added (Player player);
    public signal void removed (Player player);

    public Player? active_player { get; set; }

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
        remove (players.first_match ((p) => { return p.busname == name;}));
    }
}
