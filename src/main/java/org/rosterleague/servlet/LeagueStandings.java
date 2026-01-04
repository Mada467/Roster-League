package org.rosterleague.servlet;

import jakarta.inject.Inject;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.rosterleague.common.TeamStanding;
import org.rosterleague.ejb.RequestBean;
import org.rosterleague.entities.League;
import org.rosterleague.entities.Match;
import org.rosterleague.entities.Team;

import java.io.IOException;
import java.util.*;

@WebServlet(name = "LeagueStandings", urlPatterns = {"/LeagueStandings"})
public class LeagueStandings extends HttpServlet {

    @PersistenceContext(unitName = "em")
    private EntityManager em;

    @Inject
    private RequestBean requestBean;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String leagueIdParam = request.getParameter("leagueId");

        // Obține toate ligile pentru dropdown
        List<League> leagues = em.createQuery("SELECT l FROM League l ORDER BY l.name", League.class).getResultList();
        request.setAttribute("leagues", leagues);

        if (leagueIdParam != null && !leagueIdParam.isEmpty()) {
            try {
                Long leagueId = Long.parseLong(leagueIdParam);
                League league = em.find(League.class, leagueId);

                if (league != null) {
                    // Calculează clasamentul
                    List<TeamStanding> standings = calculateStandings(league);

                    request.setAttribute("selectedLeague", league);
                    request.setAttribute("standings", standings);
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "ID ligă invalid!");
            }
        }

        request.getRequestDispatcher("/WEB-INF/pages/leagueStandings.jsp").forward(request, response);
    }

    private List<TeamStanding> calculateStandings(League league) {
        // Map pentru a stoca statisticile fiecărei echipe
        Map<String, TeamStanding> standingsMap = new HashMap<>();

        // Inițializează toate echipele din ligă cu 0 puncte
        for (Team team : league.getTeams()) {
            standingsMap.put(team.getName(), new TeamStanding(team.getName()));
        }

        // Obține toate meciurile din ligă
        List<Match> matches = em.createQuery(
                        "SELECT m FROM Match m WHERE m.league.id = :leagueId", Match.class)
                .setParameter("leagueId", league.getId())
                .getResultList();

        // Procesează fiecare meci și actualizează statisticile
        for (Match match : matches) {
            String homeTeamName = match.getHomeTeam().getName();
            String awayTeamName = match.getAwayTeam().getName();

            TeamStanding homeStanding = standingsMap.get(homeTeamName);
            TeamStanding awayStanding = standingsMap.get(awayTeamName);

            if (homeStanding != null && awayStanding != null) {
                homeStanding.addMatchResult(match.getHomeScore(), match.getAwayScore());
                awayStanding.addMatchResult(match.getAwayScore(), match.getHomeScore());
            }
        }

        // Convertește Map în List și sortează
        List<TeamStanding> standingsList = new ArrayList<>(standingsMap.values());
        Collections.sort(standingsList);

        return standingsList;
    }
}