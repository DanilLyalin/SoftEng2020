package org.spbstu.servlet;

import com.google.gson.Gson;
import org.spbstu.database.Database;
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

@WebServlet("/game")
public class MainServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        init();
        List<Player> topPlayers = InitDatabase.getDb().getTopScore();
        String topPlayersJson = new Gson().toJson(topPlayers);
        req.setAttribute("top", topPlayersJson);
        req.getRequestDispatcher("game.jsp").forward(req, resp);
    }

    @Override
    public void init() throws ServletException {
        super.init();
        if (!InitDatabase.checkInit()) {
            InitDatabase.init();
        }
    }

}