package org.rosterleague.common;

import java.io.Serializable;

public class TeamStanding implements Serializable, Comparable<TeamStanding> {

    private String teamName;
    private int matchesPlayed;
    private int wins;
    private int draws;
    private int losses;
    private int goalsFor;
    private int goalsAgainst;
    private int goalDifference;
    private int points;

    public TeamStanding(String teamName) {
        this.teamName = teamName;
        this.matchesPlayed = 0;
        this.wins = 0;
        this.draws = 0;
        this.losses = 0;
        this.goalsFor = 0;
        this.goalsAgainst = 0;
        this.goalDifference = 0;
        this.points = 0;
    }

    // Adaugă rezultat meci
    public void addMatchResult(int goalsFor, int goalsAgainst) {
        this.matchesPlayed++;
        this.goalsFor += goalsFor;
        this.goalsAgainst += goalsAgainst;
        this.goalDifference = this.goalsFor - this.goalsAgainst;

        if (goalsFor > goalsAgainst) {
            this.wins++;
            this.points += 3;
        } else if (goalsFor == goalsAgainst) {
            this.draws++;
            this.points += 1;
        } else {
            this.losses++;
        }
    }

    // Getters
    public String getTeamName() {
        return teamName;
    }

    public int getMatchesPlayed() {
        return matchesPlayed;
    }

    public int getWins() {
        return wins;
    }

    public int getDraws() {
        return draws;
    }

    public int getLosses() {
        return losses;
    }

    public int getGoalsFor() {
        return goalsFor;
    }

    public int getGoalsAgainst() {
        return goalsAgainst;
    }

    public int getGoalDifference() {
        return goalDifference;
    }

    public int getPoints() {
        return points;
    }

    // Comparator pentru sortare descrescătoare după puncte
    @Override
    public int compareTo(TeamStanding other) {
        // Mai întâi după puncte (descrescător)
        if (this.points != other.points) {
            return other.points - this.points;
        }
        // Dacă punctele sunt egale, după golaveraj (descrescător)
        if (this.goalDifference != other.goalDifference) {
            return other.goalDifference - this.goalDifference;
        }
        // Dacă și golaverajul e egal, după goluri marcate (descrescător)
        return other.goalsFor - this.goalsFor;
    }

    @Override
    public String toString() {
        return teamName + " - Meciuri: " + matchesPlayed + ", Puncte: " + points;
    }
}