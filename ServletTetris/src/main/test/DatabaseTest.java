import org.spbstu.database.Database;
import org.spbstu.entity.Player;


import org.junit.Assert;
import org.junit.Test;


import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;


public class DatabaseTest {

    final String databaseURL = "jdbc:h2:./data/scores";
//интеграционные тесты

    @Test public void addScoreTest() {
        Player testPlayer = new Player(8000, "testing");
        Database DB = new Database();
        boolean resTest = DB.addScore(testPlayer);
        Assert.assertTrue(resTest);
    }

    @Test public void getTopScoreTest() {

            int сountShouldBe = 10;

            List<Player> resultFromMetod = new ArrayList<>();
            Database DB = new Database();
            resultFromMetod = DB.getTopScore();
            int counterFromMetod = resultFromMetod.size();

            Assert.assertEquals( сountShouldBe,  counterFromMetod);

    }

    //проверка через подсчет кол-ва строк в бд и размера списка из метода
    @Test public void getAllScoresTest() {
        try {
            Connection conn = DriverManager.getConnection(databaseURL);
            Statement statement = conn.createStatement();

            String sql = "SELECT COUNT(*) AS rowCount FROM scores ";
            ResultSet rs = statement.executeQuery(sql);
            rs.next();
            int sqlCounter = rs.getInt("rowCount");

            conn.close();

            List<Player> resultFromMetod = new ArrayList<>();
            Database DB = new Database();
            resultFromMetod = DB.getAllScores();
            int counterFromMetod = resultFromMetod.size();

            Assert.assertEquals( sqlCounter, counterFromMetod);
        }
        catch (SQLException throwables) {
            throwables.printStackTrace();
        }
    }

}