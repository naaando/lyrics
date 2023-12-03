int main (string[] args) {
    Ivy.Stacktrace.register_handlers ();

    var app = new Lyrics.Application ();
    return app.run (args);
}
