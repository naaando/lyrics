
public class Lyrics.Players : Object {
    public signal void added (Player player);
    public signal void removed (Player player);

    Mpris.Service scanner;
    Gee.ArrayList<Player> players = new Gee.ArrayList<Player> ();

    public Players () {
        setup_mpris ();
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

    void setup_mpris () {
        scanner = new Mpris.Service ();
        scanner.found.connect ((player) => add (player));
        scanner.lost.connect (remove_by_busname);
        scanner.setup_dbus ();
    }
}
