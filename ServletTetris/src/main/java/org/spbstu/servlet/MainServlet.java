package org.spbstu.servlet;

import com.google.gson.Gson;
import org.spbstu.database.InitDatabase;
import org.spbstu.entity.Player;
import org.spbstu.utils.TokenHandler;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/game")
public class MainServlet extends HttpServlet {

    @Override
    public void init() throws ServletException {
        super.init();
        if (!InitDatabase.checkInit()) {
            InitDatabase.init();
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        init();

        HttpSession session = req.getSession();
        String sessionToken = TokenHandler.getNewToken();
        session.setAttribute("auth_token", sessionToken);

        List<Player> topPlayers = InitDatabase.getDb().getTopScore();
        String topPlayersJson = new Gson().toJson(topPlayers);
        req.setAttribute("top", topPlayersJson);

        req.getRequestDispatcher("game.jsp").forward(req, resp);
    }

}