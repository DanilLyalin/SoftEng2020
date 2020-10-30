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
                    "(score_id int auto_increment, name varchar(12) NOT NULL,score int," +
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
            conn.close();
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

            String sql = "SELECT score,name FROM scores ORDER BY score DESC";
            ResultSet rs = statement.executeQuery(sql);
            while (rs.next()) {
                int score = rs.getInt("score");
                String name = rs.getString("name");
                result.add(new Player(score,name));
            }
            conn.close();
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        }
        return result;
    }

    public Boolean addScore(Player newPlayer) {
        try {
            Connection conn = DriverManager.getConnection(databaseURL);
            Statement statement = conn.createStatement();

            String sql = "SELECT score,name FROM scores WHERE name = '" + newPlayer.name+ "';";
            ResultSet rs = statement.executeQuery(sql);
            if (rs.next()){
                int oldScore = rs.getInt("score");
                if (oldScore < newPlayer.score){
                    sql = "UPDATE scores SET score = " + newPlayer.score + " WHERE name = '" + newPlayer.name + "';";
                    statement.executeUpdate(sql);
                }
            }else {
                sql = "INSERT INTO scores (name, score) VALUES('" + newPlayer.name + "'," + newPlayer.score + ");";
                statement.executeUpdate(sql);
            }
            conn.close();
        } catch (SQLException throwables) {
            return false;
        }
        return true;
    }
}
