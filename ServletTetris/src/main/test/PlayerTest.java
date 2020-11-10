import org.spbstu.entity.Player;

import java.security.InvalidParameterException;

import org.junit.Test;
import org.junit.Assert;


public class PlayerTest {

    @Test public void checkWithRighParametrs() {
        Player rightPlayer = new Player(500, "Player");
        Assert.assertNotNull(rightPlayer);
    }

    @Test(expected = InvalidParameterException.class)
    public void checkWithNegativeScore_InvalidParameterException() {
        Player InvalidScore = new Player(-9000, "testing");
    }

    @Test(expected = InvalidParameterException.class)
    public void checkWithZeroScore_InvalidParameterException() {
        Player ZeroScore = new Player(0, "testing");
    }

    @Test(expected = InvalidParameterException.class)
    public void checkWithInvalidName_InvalidParameterException() {
        Player InvalidName = new Player(5000, "E3q.7");
    }

}
