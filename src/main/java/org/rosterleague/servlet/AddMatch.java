package org.rosterleague.servlet;

import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.rosterleague.common.Request;
import org.rosterleague.entities.League;
import org.rosterleague.entities.Team;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AddMatch", urlPatterns = {"/AddMatch"})
public class AddMatch extends HttpServlet {

    @Inject
    Request ejbRequest;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Obține toate ligile și echipele pentru dropdown-uri
        // (Aici ar trebui să folosești metode din ejbRequest pentru a obține liste)
        // Deocamdată trimitem direct la JSP

        request.getRequestDispatcher("/WEB-INF/pages/addMatch.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String leagueId = request.getParameter("leagueId");
            String homeTeamId = request.getParameter("homeTeamId");
            String awayTeamId = request.getParameter("awayTeamId");
            int homeScore = Integer.parseInt(request.getParameter("homeScore"));
            int awayScore = Integer.parseInt(request.getParameter("awayScore"));

            // Validare
            if (homeTeamId.equals(awayTeamId)) {
                request.setAttribute("error", "O echipă nu poate juca împotriva ei înșiși!");
                doGet(request, response);
                return;
            }

            // Creează meciul
            ejbRequest.createMatch(homeTeamId, awayTeamId, homeScore, awayScore, leagueId);

            // Redirect cu succes
            response.sendRedirect(request.getContextPath() + "/LeagueStandings?leagueId=" + leagueId + "&success=true");

        } catch (Exception e) {
            request.setAttribute("error", "Eroare: " + e.getMessage());
            doGet(request, response);
        }
    }
}