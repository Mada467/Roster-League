package org.rosterleague.servlet;

import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.rosterleague.common.*;
import org.rosterleague.entities.Match;
import java.io.IOException;
import java.util.*;

@WebServlet(name = "LeagueStandings", urlPatterns = {"/LeagueStandings"})
public class LeagueStandings extends HttpServlet {

    @Inject
    Request ejbRequest;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<LeagueDetails> leagues = ejbRequest.getAllLeagues();
        request.setAttribute("leagues", leagues);

        String leagueId = request.getParameter("leagueId");
        if (leagueId != null && !leagueId.isEmpty()) {
            List<TeamStanding> standings = calculateStandings(leagueId);
            request.setAttribute("standings", standings);

            LeagueDetails currentLeague = ejbRequest.getLeague(leagueId);
            request.setAttribute("leagueName", currentLeague.getName());
            request.setAttribute("selectedLeagueId", leagueId);
        }

        request.getRequestDispatcher("/WEB-INF/pages/leagueStandings.jsp").forward(request, response);
    }

    private List<TeamStanding> calculateStandings(String leagueId) {
        Map<String, TeamStanding> map = new HashMap<>();
        List<TeamDetails> teams = ejbRequest.getTeamsOfLeague(leagueId);

        for (TeamDetails t : teams) {
            TeamStanding ts = new TeamStanding(t.getName());
            ts.setTeamId(t.getId()); // ACUM FUNCȚIONEAZĂ!
            map.put(t.getId(), ts);
        }

        List<Match> matches = ejbRequest.getMatchesOfLeague(leagueId);
        if (matches != null) {
            for (Match m : matches) {
                TeamStanding home = map.get(m.getHomeTeam().getId());
                TeamStanding away = map.get(m.getAwayTeam().getId());

                if (home != null && away != null) {
                    home.addMatchResult(m.getHomeScore(), m.getAwayScore());
                    away.addMatchResult(m.getAwayScore(), m.getHomeScore());
                }
            }
        }

        List<TeamStanding> list = new ArrayList<>(map.values());
        Collections.sort(list);
        return list;
    }
}