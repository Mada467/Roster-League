package org.rosterleague.servlet;

import jakarta.inject.Inject;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.transaction.Transactional;
import org.rosterleague.ejb.RequestBean;
import org.rosterleague.entities.League;
import org.rosterleague.entities.Match;
import org.rosterleague.entities.Team;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AddMatch", urlPatterns = {"/AddMatch"})
@Transactional
public class AddMatch extends HttpServlet {

    @PersistenceContext(unitName = "em")
    private EntityManager em;

    @Inject
    private RequestBean requestBean;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Obține toate ligile pentru dropdown
        List<League> leagues = em.createQuery("SELECT l FROM League l", League.class).getResultList();
        request.setAttribute("leagues", leagues);

        // Obține toate echipele pentru dropdown
        List<Team> teams = em.createQuery("SELECT t FROM Team t ORDER BY t.name", Team.class).getResultList();
        request.setAttribute("teams", teams);

        request.getRequestDispatcher("/WEB-INF/pages/addMatch.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Preiau parametrii din formular
            Long leagueId = Long.parseLong(request.getParameter("leagueId"));
            Long homeTeamId = Long.parseLong(request.getParameter("homeTeamId"));
            Long awayTeamId = Long.parseLong(request.getParameter("awayTeamId"));
            int homeScore = Integer.parseInt(request.getParameter("homeScore"));
            int awayScore = Integer.parseInt(request.getParameter("awayScore"));

            // Validare: echipele trebuie să fie diferite
            if (homeTeamId.equals(awayTeamId)) {
                request.setAttribute("error", "O echipă nu poate juca împotriva ei înșiși!");
                doGet(request, response);
                return;
            }

            // Găsesc entitățile
            League league = em.find(League.class, leagueId);
            Team homeTeam = em.find(Team.class, homeTeamId);
            Team awayTeam = em.find(Team.class, awayTeamId);

            // Validare: ambele echipe trebuie să fie în aceeași ligă
            if (!homeTeam.getLeagues().contains(league) || !awayTeam.getLeagues().contains(league)) {
                request.setAttribute("error", "Ambele echipe trebuie să fie în liga selectată!");
                doGet(request, response);
                return;
            }

            // Creez și salvez meciul
            Match match = new Match(homeTeam, awayTeam, homeScore, awayScore, league);
            em.persist(match);

            // Redirecționez cu mesaj de succes
            response.sendRedirect(request.getContextPath() + "/LeagueStandings?leagueId=" + leagueId + "&success=true");

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Date invalide! Verificați câmpurile.");
            doGet(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Eroare la salvarea meciului: " + e.getMessage());
            doGet(request, response);
        }
    }
}