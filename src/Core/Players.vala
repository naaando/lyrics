
public class Lyrics.Players : Gee.ArrayList<Player>, Object {
    public Players () {
        setup_mpris ();
    }

    public void remove_by_busname (string name) {
        remove (first_match ((p) => { return p.busname == name;}));
    }

    void setup_mpris () {
        var scanner = new Mpris.Service ();

        scanner.found.connect ((player) => {
            if (add (player)) {
                debug (@"Player added $(p.busname)\n");
            }
        });

        scanner.lost.connect (remove_player_by_busname);
    }
}
