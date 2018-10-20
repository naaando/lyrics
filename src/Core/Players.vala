
public class Lyrics.Players : Gee.ArrayList<Player> {
    public signal void added (Player player);
    public signal void removed (Player player);

    Mpris.Service scanner;

    public Players () {
        setup_mpris ();
    }

    public override bool add (Player player) {
        print (@"Adding\n");
        if (base.add (player)) {
            added (player);
            return true;
        }

        return false;
    }

    public override bool remove (Player player) {
        if (base.remove (player)) {
            removed (player);
            return true;
        }

        return false;
    }

    public void remove_by_busname (string name) {
        remove (first_match ((p) => { return p.busname == name;}));
    }

    void setup_mpris () {
        scanner = new Mpris.Service ();

        scanner.found.connect ((player) => {
            if (add (player)) {
                debug (@"MPris player added $(player.busname)\n");
            }
        });

        scanner.lost.connect (remove_by_busname);
    }
}
