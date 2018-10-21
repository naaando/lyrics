
public class Lyrics.Players : Object {
    public signal void added (Player player);
    public signal void removed (Player player);

    Gee.ArrayList<Player> players = new Gee.ArrayList<Player> ();

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
