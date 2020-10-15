package org.spbstu.database;

import org.spbstu.entity.Player;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class Database {

    final String databaseURL = "jdbc:h2:./data/scores";

    public Database() {
        try {
            Connection conn = DriverManager.getConnection(databaseURL);
            Statement statement = conn.createStatement();

            String sql = "CREATE TABLE IF NOT EXISTS scores " +
                    "(score_id int primary key, name varchar(20) NOT NULL,score int," +
                    "UNIQUE KEY name (name))";
            statement.execute(sql);
            conn.close();
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        }
    }

    public List<Player> getTopScore() {
        List<Player> result = new ArrayList<>();
        Integer topSize = 10;
        try {
            Connection conn = DriverManager.getConnection(databaseURL);
            Statement statement = conn.createStatement();

            String sql = "SELECT TOP " + topSize + " name,score FROM scores ORDER BY score DESC";
            ResultSet rs = statement.executeQuery(sql);
            while (rs.next()) {
                int score = rs.getInt("score");
                String name = rs.getString("name");
                result.add(new Player(score,name));
            }
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        }
        return result;
    }

    public List<Player> getAllScores() {
        List<Player> result = new ArrayList<>();
        try {
            Connection conn = DriverManager.getConnection(databaseURL);
            Statement statement = conn.createStatement();

            String sql = "SELECT score,name FROM scores ORDER BY name ASC";
            ResultSet rs = statement.executeQuery(sql);
            while (rs.next()) {
                int score = rs.getInt("score");
                String name = rs.getString("name");
                result.add(new Player(score,name));
            }
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        }
        return result;
    }
}
