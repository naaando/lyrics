using GLib;

public abstract class MockClass : Object {
    public MockMethod should_call (string method_name) {
        GLib.Value value = GLib.Value (typeof (MockMethod));
        var prop = (method_name + "_mock");
        this.get_property (prop, ref value);
        return value.get_object () as MockMethod;
    }
}
