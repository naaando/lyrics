
public class Lyrics.Service.PlayerStateService : Object {
    public signal void state_changed (Player? player, Player.State state);
    public signal void player_added (Player player);
    public signal void player_removed (Player player);

    private Player? player;
    private Gee.ArrayList<Player> players;

    public PlayerStateService () {
        players = new Gee.ArrayList<Player>();
        //  add_player (factory_simple_player ());
        setup_mpris ();
    }

    ~PlayerStateService () {
        info ("Player service destroyed\n");
    }

    public Player.State get_player_state () {
        if (player == null) {
            return Player.State.NO_PLAYER;
        }

        return player.state;
    }

    public Player[]? list_players () {
        return players.to_array ();
    }

    public void set_player (Player p) {
        player = p;

        state_changed (player, get_player_state ());

        player.notify["state"].connect (() => {
            state_changed (player, get_player_state ());
        });

        player.notify["current-song"].connect (() => {
            state_changed (player, get_player_state ());
        });
    }

    void add_player (Player p) {
        players.add (p);
        player_added (p);

        if (player == null) {
            set_player(p);
        }

        print (@"Player added $(p.busname)\n");
    }

    void remove_player (Player p) {
        players.remove(p);
        player_removed (p);

        if (p == player) {
            player = null;
            state_changed (null, get_player_state ());
        }

        print (@"Player removed $(p.busname)\n");
    }

    void remove_player_by_busname (string name) {
        remove_player (players.first_match ((p) => { return p.busname == name;}));
    }

    Player factory_simple_player () {
        return new SimplePlayer ("Sample", Factory.MetasongFactory.get_unknow_metasong ());
    }

    void setup_mpris () {
        var scanner = new Mpris.Service ();
        scanner.found.connect (add_player);
        scanner.lost.connect (remove_player_by_busname);
    }
}
