package org.rosterleague.servlet;

import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.rosterleague.common.Request;
import org.rosterleague.entities.Match;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "TeamMatches", urlPatterns = {"/TeamMatches"})
public class TeamMatches extends HttpServlet {

    @Inject
    Request ejbRequest;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String teamId = request.getParameter("teamId");
        String teamName = request.getParameter("teamName");

        if (teamId != null) {
            // Chemăm metoda din RequestBean-ul tău
            List<Match> matches = ejbRequest.getMatchesOfTeam(teamId);
            request.setAttribute("matches", matches);
            request.setAttribute("teamName", teamName);
        }

        request.getRequestDispatcher("/WEB-INF/pages/teamMatches.jsp").forward(request, response);
    }
}