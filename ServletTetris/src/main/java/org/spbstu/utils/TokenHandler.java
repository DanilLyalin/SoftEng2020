package org.spbstu.utils;

import java.time.Instant;
import java.util.HashSet;
import java.util.Set;
import java.util.UUID;

public class TokenHandler {
    private static Set<String> validTokens = new HashSet<String>();

    public static String getNewToken() {
        StringBuilder sb = new StringBuilder();
        long currentTimeInMilisecond = Instant.now().toEpochMilli();
        sb.append(currentTimeInMilisecond).append("-")
                .append(UUID.randomUUID().toString()).toString();
        String token = sb.toString();
        validTokens.add(token);
        return token;
    }

    public static Boolean checkToken(String token) {
        return validTokens.contains(token);
    }

    public static void deleteToken(String token) {
        validTokens.remove(token);
    }
}
