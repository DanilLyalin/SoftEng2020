package org.spbstu.servlet;

import org.spbstu.database.InitDatabase;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
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
        super.doPost(req, resp);
        //TODO: Add a check for a valid http session from the game page
        //      Add a check for name length and score size
    }
}