public errordomain ExpectationFailed {
    METHOD_NOT_CALLED,
    METHOD_CALLED_TOO_MANY_TIMES,
}

public class MockMethod : Object {
    int expected = 0;
    int executed_count = 0;

    ~MockMethod () {
        if (executed_count < expected) {
            throw new ExpectationFailed.METHOD_NOT_CALLED("Method not called");
        }
    }

    public void call () throws ExpectationFailed {
        debug ("MockMethod.call()");

        if (executed_count >= expected) {
            throw new ExpectationFailed.METHOD_CALLED_TOO_MANY_TIMES("Method called too many times");
        }

        executed_count = executed_count + 1;
    }

    public MockMethod never () {
        return times(0);
    }

    public MockMethod once () {
        return times(1);
    }

    public MockMethod twice () {
        return times(2);
    }

    public MockMethod times (int times) {
        expected = expected + 1;
        return this;
    }
}
