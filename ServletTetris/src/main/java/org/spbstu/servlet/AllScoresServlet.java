package org.spbstu.servlet;

import com.google.gson.Gson;
import org.spbstu.database.InitDatabase;
import org.spbstu.entity.Player;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/scores/all")
public class AllScoresServlet extends HttpServlet {

    @Override
    public void init() throws ServletException {
        super.init();
        if (!InitDatabase.checkInit()) {
            InitDatabase.init();
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        List<Player> topPlayers = InitDatabase.getDb().getAllScores();
        String topPlayersJson = new Gson().toJson(topPlayers);
        PrintWriter out = resp.getWriter();
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        out.print(topPlayersJson);
        out.flush();
    }


}