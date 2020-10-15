package org.spbstu.entity;

public class Player {
    public int score;
    public String name;

    public Player(int score,String name){
        this.score = score;
        this.name = name;
    }

    @Override
    public String toString() {
        return "Player{" +
                "score=" + score +
                ", name='" + name + '\'' +
                '}';
    }
}
