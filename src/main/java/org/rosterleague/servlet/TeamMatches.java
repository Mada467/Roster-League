package org.rosterleague.servlet;

import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.rosterleague.common.Request;
import org.rosterleague.common.TeamDetails;
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

        String teamIdParam = request.getParameter("teamId");

        // Obține toate echipele pentru dropdown
        List<TeamDetails> teams = ejbRequest.getTeamsOfLeague("L1");
        try {
            teams.addAll(ejbRequest.getTeamsOfLeague("L2"));
            teams.addAll(ejbRequest.getTeamsOfLeague("L3"));
            teams.addAll(ejbRequest.getTeamsOfLeague("L4"));
        } catch (Exception e) {
            // Ignoră
        }

        request.setAttribute("teams", teams);

        if (teamIdParam != null && !teamIdParam.isEmpty()) {
            try {
                TeamDetails team = ejbRequest.getTeam(teamIdParam);

                if (team != null) {
                    // Obține toate meciurile echipei
                    List<Match> matches = ejbRequest.getMatchesOfTeam(teamIdParam);

                    // Calculează statistici
                    int totalMatches = matches.size();
                    int wins = 0;
                    int draws = 0;
                    int losses = 0;
                    int goalsFor = 0;
                    int goalsAgainst = 0;
                    int points = 0;

                    for (Match match : matches) {
                        boolean isHome = match.getHomeTeam().getId().equals(teamIdParam);
                        int teamGoals = isHome ? match.getHomeScore() : match.getAwayScore();
                        int opponentGoals = isHome ? match.getAwayScore() : match.getHomeScore();

                        goalsFor += teamGoals;
                        goalsAgainst += opponentGoals;

                        if (teamGoals > opponentGoals) {
                            wins++;
                            points += 3;
                        } else if (teamGoals == opponentGoals) {
                            draws++;
                            points += 1;
                        } else {
                            losses++;
                        }
                    }

                    request.setAttribute("selectedTeam", team);
                    request.setAttribute("matches", matches);
                    request.setAttribute("totalMatches", totalMatches);
                    request.setAttribute("wins", wins);
                    request.setAttribute("draws", draws);
                    request.setAttribute("losses", losses);
                    request.setAttribute("goalsFor", goalsFor);
                    request.setAttribute("goalsAgainst", goalsAgainst);
                    request.setAttribute("goalDifference", goalsFor - goalsAgainst);
                    request.setAttribute("points", points);
                }
            } catch (Exception e) {
                request.setAttribute("error", "Eroare: " + e.getMessage());
            }
        }

        request.getRequestDispatcher("/WEB-INF/pages/teamMatches.jsp").forward(request, response);
    }
}