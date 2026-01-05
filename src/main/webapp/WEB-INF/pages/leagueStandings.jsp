<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Clasamente - Roster League</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4 shadow-sm">
    <div class="container">
        <a class="navbar-brand fw-bold" href="LeagueStandings">🏆 RosterLeague</a>
        <div class="navbar-nav">
            <a class="nav-link active" href="LeagueStandings">Clasamente</a>
            <a class="nav-link" href="AddMatch">Adaugă Meci</a>
        </div>
    </div>
</nav>

<div class="container">
    <div class="card p-4 shadow-sm border-0 mb-4">
        <h2 class="mb-4 text-primary">Vizualizare Clasament</h2>
        <form action="LeagueStandings" method="GET" class="row g-3">
            <div class="col-md-9">
                <select name="leagueId" class="form-select form-select-lg">
                    <option value="">-- Alege o competiție --</option>
                    <c:forEach items="${leagues}" var="l">
                        <option value="${l.id}" ${l.id == selectedLeagueId ? 'selected' : ''}>
                                ${l.name} (${l.sport})
                        </option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-md-3">
                <button type="submit" class="btn btn-primary btn-lg w-100">Afișează</button>
            </div>
        </form>
    </div>

    <c:if test="${not empty standings}">
        <div class="card shadow-sm border-0">
            <div class="card-header bg-dark text-white text-center py-3">
                <h4 class="mb-0">Clasament: ${leagueName}</h4>
            </div>
            <div class="table-responsive">
                <table class="table table-hover mb-0 text-center align-middle">
                    <thead class="table-secondary">
                    <tr>
                        <th class="text-start ps-4">Echipă</th>
                        <th>M</th><th>V</th><th>E</th><th>Î</th><th>Golaveraj</th><th>Pct</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${standings}" var="s">
                        <tr>
                            <td class="fw-bold text-start ps-4">
                                    <%-- LINK CORECTAT: Trimitem teamId pentru baza de date și teamName pentru titlu --%>
                                <a href="TeamMatches?teamId=${s.teamId}&teamName=${s.teamName}" class="text-decoration-none">
                                        ${s.teamName}
                                </a>
                            </td>
                            <td>${s.matchesPlayed}</td>
                            <td class="text-success fw-bold">${s.wins}</td>
                            <td>${s.draws}</td>
                            <td class="text-danger">${s.losses}</td>
                                <%-- Folosim proprietățile goalsFor și goalsAgainst definite în TeamStanding --%>
                            <td>${s.goalsFor} - ${s.goalsAgainst}</td>
                            <td><span class="badge bg-primary fs-6">${s.points}</span></td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </c:if>
</div>
</body>
</html>