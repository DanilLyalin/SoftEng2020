package org.spbstu.database;

public class InitDatabase {
    private static Database db = null;

    public static void init() {
        db = new Database();
    }

    public static boolean checkInit() {
        return db != null;
    }

    public static Database getDb() {
        return db;
    }
}
