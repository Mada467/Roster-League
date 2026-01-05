package org.rosterleague.servlet;

import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.rosterleague.common.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AddMatch", urlPatterns = {"/AddMatch"})
public class AddMatch extends HttpServlet {

    @Inject
    Request ejbRequest;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<LeagueDetails> leagues = ejbRequest.getAllLeagues();
        request.setAttribute("leagues", leagues);

        String leagueId = request.getParameter("leagueId");
        if (leagueId != null && !leagueId.isEmpty()) {
            List<TeamDetails> teams = ejbRequest.getTeamsOfLeague(leagueId);
            request.setAttribute("teams", teams);
            request.setAttribute("selectedLeagueId", leagueId);
        }

        request.getRequestDispatcher("/WEB-INF/pages/addMatch.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String leagueId = request.getParameter("leagueId");
        ejbRequest.createMatch(
                request.getParameter("homeTeamId"),
                request.getParameter("awayTeamId"),
                Integer.parseInt(request.getParameter("homeScore")),
                Integer.parseInt(request.getParameter("awayScore")),
                leagueId
        );

        response.sendRedirect("LeagueStandings?leagueId=" + leagueId);
    }
}