import org.spbstu.utils.TokenHandler;

import org.junit.Assert;
import org.junit.Test;

public class TokenTest {

    @Test public void checkTokenHandler() {
        String token = TokenHandler.getNewToken();
        Assert.assertTrue(TokenHandler.checkToken(token));
        TokenHandler.deleteToken(token);
        Assert.assertFalse(TokenHandler.checkToken(token));
    }

}
