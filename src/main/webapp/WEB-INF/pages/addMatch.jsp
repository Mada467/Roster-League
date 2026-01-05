<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Adaugă Meci - Roster League</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4 shadow-sm">
    <div class="container">
        <a class="navbar-brand fw-bold" href="LeagueStandings">🏆 RosterLeague</a>
        <div class="navbar-nav">
            <a class="nav-link" href="LeagueStandings">Clasamente</a>
            <a class="nav-link active" href="AddMatch">Adaugă Meci</a>
        </div>
    </div>
</nav>

<div class="container py-4">
    <div class="card p-4 shadow-sm border-0 mb-4">
        <h2 class="text-success mb-4">Adaugă Rezultat Nou</h2>
        <form action="AddMatch" method="GET" class="mb-4">
            <label class="form-label fw-bold">1. Selectează Liga</label>
            <select name="leagueId" class="form-select" onchange="this.form.submit()">
                <option value="">-- Alege Liga --</option>
                <c:forEach items="${leagues}" var="l">
                    <option value="${l.id}" ${l.id == selectedLeagueId ? 'selected' : ''}>${l.name}</option>
                </c:forEach>
            </select>
        </form>

        <c:if test="${not empty teams}">
            <form action="AddMatch" method="POST">
                <input type="hidden" name="leagueId" value="${selectedLeagueId}">
                <div class="row g-4 text-center">
                    <div class="col-md-5">
                        <select name="homeTeamId" class="form-select mb-2" required>
                            <c:forEach items="${teams}" var="t">
                                <option value="${t.id}">${t.name}</option>
                            </c:forEach>
                        </select>
                        <input type="number" name="homeScore" class="form-control form-control-lg text-center" placeholder="0" min="0" required>
                    </div>
                    <div class="col-md-2 align-self-center"><h3>VS</h3></div>
                    <div class="col-md-5">
                        <select name="awayTeamId" class="form-select mb-2" required>
                            <c:forEach items="${teams}" var="t">
                                <option value="${t.id}">${t.name}</option>
                            </c:forEach>
                        </select>
                        <input type="number" name="awayScore" class="form-control form-control-lg text-center" placeholder="0" min="0" required>
                    </div>
                </div>
                <button type="submit" class="btn btn-success btn-lg w-100 mt-5 shadow-sm">Salvează Meci</button>
            </form>
        </c:if>
    </div>
</div>
</body>
</html>