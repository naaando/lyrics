public abstract class Unit.TestCase : Object {
    protected void register(string path, GLib.TestDataFunc fn) {
        var class_name = camel_to_snake(this.get_class().get_name());

        Test.add_data_func(@"/$class_name" + path, () => {
            setup();
            fn();
            teardown();
        });
    }

    protected virtual void setup() {
        //
    }

    protected virtual void teardown() {
        //
    }

    private string camel_to_snake(string input) {
        StringBuilder slug_builder = new StringBuilder();
        bool lastWasLower = false;

        for (int i = 0; i < input.length; i++) {
            char c = input[i];

            // If the character is uppercase, add a separator
            if (c.isupper() && lastWasLower && i != 0) {
                slug_builder.append("_");
            }

            // Append the lowercase version of the character
            slug_builder.append(c.tolower().to_string());

            // Track the case of the last character
            lastWasLower = c.islower();
        }

        return slug_builder.str;
    }
}
