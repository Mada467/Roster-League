package org.rosterleague.common;

import java.io.Serializable;

public class TeamStanding implements Serializable, Comparable<TeamStanding> {
    private String teamId;
    private String teamName;
    private int matchesPlayed = 0;
    private int wins = 0;
    private int draws = 0;
    private int losses = 0;
    private int goalsScored = 0;
    private int goalsAgainst = 0;
    private int points = 0;

    public TeamStanding(String teamName) {
        this.teamName = teamName;
    }

    // Metodele cerute de JSP (Repară HTTP 500)
    public int getGoalsFor() { return goalsScored; }
    public int getGoalsAgainst() { return goalsAgainst; }
    public String getGoals() { return goalsScored + " - " + goalsAgainst; }

    // Metodele pentru ID și Nume
    public String getTeamId() { return teamId; }
    public void setTeamId(String teamId) { this.teamId = teamId; }
    public String getTeamName() { return teamName; }

    // Metodele pentru Statistici
    public int getMatchesPlayed() { return matchesPlayed; }
    public int getWins() { return wins; }
    public int getDraws() { return draws; }
    public int getLosses() { return losses; }
    public int getPoints() { return points; }

    public void addMatchResult(int scored, int against) {
        this.matchesPlayed++;
        this.goalsScored += scored;
        this.goalsAgainst += against;
        if (scored > against) {
            this.wins++;
            this.points += 3;
        } else if (scored == against) {
            this.draws++;
            this.points += 1;
        } else {
            this.losses++;
        }
    }

    @Override
    public int compareTo(TeamStanding o) {
        return Integer.compare(o.points, this.points);
    }
}