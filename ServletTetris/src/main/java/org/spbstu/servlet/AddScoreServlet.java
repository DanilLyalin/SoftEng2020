package org.spbstu.servlet;

import com.google.gson.JsonElement;
import com.google.gson.JsonParser;
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

@WebServlet("/scores/add")
public class AddScoreServlet extends HttpServlet {

    @Override
    public void init() throws ServletException {
        super.init();
        if (!InitDatabase.checkInit()) {
            InitDatabase.init();
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        String sessionToken = (String) session.getAttribute("auth_token");
        if (TokenHandler.checkToken(sessionToken)){
            TokenHandler.deleteToken(sessionToken);
            Player newPlayer = null;
            try {
                JsonElement elems = new JsonParser().parse(req.getReader());
                String newName = elems.getAsJsonObject().get("name").getAsString();
                Integer newScore = elems.getAsJsonObject().get("score").getAsInt();
                newPlayer = new Player(newScore,newName);
            }catch (Exception e){
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                return;
            }
            Boolean addStatus = InitDatabase.getDb().addScore(newPlayer);
            if (addStatus){
                resp.setStatus(HttpServletResponse.SC_ACCEPTED);
            }else{
                resp.setStatus(HttpServletResponse.SC_CONFLICT);
            }

        }
        else{
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        }
    }

}