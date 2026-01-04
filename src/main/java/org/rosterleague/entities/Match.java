package org.rosterleague.entities;

import jakarta.persistence.*;
import java.io.Serializable;

@Entity
@Table(name = "matches")
public class Match implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "home_team_id", nullable = false)
    private Team homeTeam;

    @ManyToOne
    @JoinColumn(name = "away_team_id", nullable = false)
    private Team awayTeam;

    @Column(nullable = false)
    private int homeScore;

    @Column(nullable = false)
    private int awayScore;

    @ManyToOne
    @JoinColumn(name = "league_id", nullable = false)
    private League league;

    // Constructor gol (necesar pentru JPA)
    public Match() {
    }

    // Constructor cu parametri
    public Match(Team homeTeam, Team awayTeam, int homeScore, int awayScore, League league) {
        this.homeTeam = homeTeam;
        this.awayTeam = awayTeam;
        this.homeScore = homeScore;
        this.awayScore = awayScore;
        this.league = league;
    }

    // Getters și Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Team getHomeTeam() {
        return homeTeam;
    }

    public void setHomeTeam(Team homeTeam) {
        this.homeTeam = homeTeam;
    }

    public Team getAwayTeam() {
        return awayTeam;
    }

    public void setAwayTeam(Team awayTeam) {
        this.awayTeam = awayTeam;
    }

    public int getHomeScore() {
        return homeScore;
    }

    public void setHomeScore(int homeScore) {
        this.homeScore = homeScore;
    }

    public int getAwayScore() {
        return awayScore;
    }

    public void setAwayScore(int awayScore) {
        this.awayScore = awayScore;
    }

    public League getLeague() {
        return league;
    }

    public void setLeague(League league) {
        this.league = league;
    }

    // Metodă helper pentru a determina câștigătorul
    public String getResult() {
        if (homeScore > awayScore) {
            return "HOME_WIN";
        } else if (awayScore > homeScore) {
            return "AWAY_WIN";
        } else {
            return "DRAW";
        }
    }

    // Metodă pentru a obține punctele echipei de acasă
    public int getHomeTeamPoints() {
        if (homeScore > awayScore) return 3;
        if (homeScore == awayScore) return 1;
        return 0;
    }

    // Metodă pentru a obține punctele echipei din deplasare
    public int getAwayTeamPoints() {
        if (awayScore > homeScore) return 3;
        if (homeScore == awayScore) return 1;
        return 0;
    }

    @Override
    public String toString() {
        return homeTeam.getName() + " " + homeScore + " - " + awayScore + " " + awayTeam.getName();
    }
}