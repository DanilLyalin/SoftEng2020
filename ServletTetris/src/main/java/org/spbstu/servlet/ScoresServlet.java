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
import java.util.List;

@WebServlet("/scores")
public class ScoresServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        init();

        List<Player> allPlayers = InitDatabase.getDb().getAllScores();
        String allPlayersJson = new Gson().toJson(allPlayers);
        req.setAttribute("all", allPlayersJson);

        req.getRequestDispatcher("scores.jsp").forward(req, resp);
    }

    @Override
    public void init() throws ServletException {
        super.init();
        if (!InitDatabase.checkInit()) {
            InitDatabase.init();
        }
    }
}