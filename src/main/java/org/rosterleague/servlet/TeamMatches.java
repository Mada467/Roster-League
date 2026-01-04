package org.rosterleague.servlet;

import jakarta.inject.Inject;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.rosterleague.ejb.RequestBean;
import org.rosterleague.entities.Match;
import org.rosterleague.entities.Team;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "TeamMatches", urlPatterns = {"/TeamMatches"})
public class TeamMatches extends HttpServlet {

    @PersistenceContext(unitName = "em")
    private EntityManager em;

    @Inject
    private RequestBean requestBean;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String teamIdParam = request.getParameter("teamId");

        // Obține toate echipele pentru dropdown
        List<Team> teams = em.createQuery("SELECT t FROM Team t ORDER BY t.name", Team.class).getResultList();
        request.setAttribute("teams", teams);

        if (teamIdParam != null && !teamIdParam.isEmpty()) {
            try {
                Long teamId = Long.parseLong(teamIdParam);
                Team team = em.find(Team.class, teamId);

                if (team != null) {
                    // Obține toate meciurile în care echipa a jucat (acasă sau deplasare)
                    List<Match> matches = em.createQuery(
                                    "SELECT m FROM Match m WHERE m.homeTeam.id = :teamId OR m.awayTeam.id = :teamId ORDER BY m.id DESC",
                                    Match.class)
                            .setParameter("teamId", teamId)
                            .getResultList();

                    // Calculează statistici
                    int totalMatches = matches.size();
                    int wins = 0;
                    int draws = 0;
                    int losses = 0;
                    int goalsFor = 0;
                    int goalsAgainst = 0;
                    int points = 0;

                    for (Match match : matches) {
                        boolean isHome = match.getHomeTeam().getId().equals(teamId);
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
            } catch (NumberFormatException e) {
                request.setAttribute("error", "ID echipă invalid!");
            }
        }

        request.getRequestDispatcher("/WEB-INF/pages/teamMatches.jsp").forward(request, response);
    }
}