package org.spbstu.entity;

import java.security.InvalidParameterException;

public class Player {
    public int score;
    public String name;

    public Player(int score,String name) throws InvalidParameterException{
        if (score > 0 && name.matches("^[a-zA-Z0-9]+$") && name.length() < 12) {
            this.score = score;
            this.name = name;
        }
        else{
            throw new InvalidParameterException();
        }

    }
}
