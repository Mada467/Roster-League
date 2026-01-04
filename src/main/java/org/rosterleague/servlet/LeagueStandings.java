package org.rosterleague.servlet;

import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.rosterleague.common.LeagueDetails;
import org.rosterleague.common.Request;
import org.rosterleague.common.TeamDetails;
import org.rosterleague.common.TeamStanding;
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

        String leagueIdParam = request.getParameter("leagueId");

        // Creează lista de ligi hardcodat
        List<SimpleLeague> leagues = new ArrayList<>();
        leagues.add(new SimpleLeague("L1", "Mountain Soccer"));
        leagues.add(new SimpleLeague("L2", "Valley Basketball"));
        leagues.add(new SimpleLeague("L3", "Foothills Soccer"));
        leagues.add(new SimpleLeague("L4", "Alpine Snowboarding"));

        request.setAttribute("leagues", leagues);

        if (leagueIdParam != null && !leagueIdParam.isEmpty()) {
            try {
                LeagueDetails league = ejbRequest.getLeague(leagueIdParam);

                if (league != null) {
                    List<TeamStanding> standings = calculateStandings(leagueIdParam);

                    request.setAttribute("selectedLeague", league);
                    request.setAttribute("standings", standings);
                }
            } catch (Exception e) {
                request.setAttribute("error", "Eroare: " + e.getMessage());
            }
        }

        request.getRequestDispatcher("/WEB-INF/pages/leagueStandings.jsp").forward(request, response);
    }

    private List<TeamStanding> calculateStandings(String leagueId) {
        Map<String, TeamStanding> standingsMap = new HashMap<>();

        try {
            List<TeamDetails> teams = ejbRequest.getTeamsOfLeague(leagueId);

            for (TeamDetails team : teams) {
                standingsMap.put(team.getId(), new TeamStanding(team.getName()));
            }

            List<Match> matches = ejbRequest.getMatchesOfLeague(leagueId);

            for (Match match : matches) {
                String homeTeamId = match.getHomeTeam().getId();
                String awayTeamId = match.getAwayTeam().getId();

                TeamStanding homeStanding = standingsMap.get(homeTeamId);
                TeamStanding awayStanding = standingsMap.get(awayTeamId);

                if (homeStanding != null && awayStanding != null) {
                    homeStanding.addMatchResult(match.getHomeScore(), match.getAwayScore());
                    awayStanding.addMatchResult(match.getAwayScore(), match.getHomeScore());
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        List<TeamStanding> standingsList = new ArrayList<>(standingsMap.values());
        Collections.sort(standingsList);

        return standingsList;
    }

    // Clasă simplă pentru ligi
    public static class SimpleLeague {
        private String id;
        private String name;

        public SimpleLeague(String id, String name) {
            this.id = id;
            this.name = name;
        }

        public String getId() { return id; }
        public String getName() { return name; }
    }
}