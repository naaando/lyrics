
public class Mpris.Service : Object {
    public signal void found (Mpris.Player player);
    public signal void lost (string name);

    void add (string name) {
        // delay the sync because otherwise the dbus properties are not yet intialized!
        Timeout.add (200, () => {
            var player = new Mpris.Player (name);
            found (player);
            return false;
        });
    }

    void remove (string name) {
        lost (name);
    }

    public void setup_dbus () {
        DBusImpl impl = null;

        try {
            impl = Bus.get_proxy_sync (BusType.SESSION, "org.freedesktop.DBus", "/org/freedesktop/DBus");

            /* Search for existing players (launched prior to our start) */
            foreach (var name in impl.list_names ()) {
                if (name.has_prefix("org.mpris.MediaPlayer2.")) {
                    // skip if already a interface is present.
                    // some version of vlc register two
                    add (name);
                }
            }

            new Thread<int>.try ("mpris", () => {
                var loop = new MainLoop ();
                /* Also check for new mpris clients coming up while we're up */
                impl.name_owner_changed.connect ((n,o,ne) => {
                    /* Separate.. */
                    if (n.has_prefix("org.mpris.MediaPlayer2.")) {
                        if (o == "") {
                            add (n);
                        } else {
                            remove (n);
                        }
                    }
                });
                loop.run ();

                return 0;
            });
        } catch (Error e) {
            warning("Failed to initialise dbus: %s", e.message);
        }
    }
}
