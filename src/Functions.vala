void dump_hashtable(GLib.HashTable<string, Variant> ht) {
    debug ("Dumping hashtable\n");

    ht.foreach ((key, value) => {
        debug (key + value.print(true) + "\n");
    });
}