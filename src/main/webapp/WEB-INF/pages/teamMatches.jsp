<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Istoric - ${teamName}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .match-card { border-radius: 15px; overflow: hidden; }
        .score-box { background: #212529; color: white; min-width: 80px; border-radius: 8px; }
    </style>
</head>
<body class="bg-light">

<%-- Navigarea pe care am construit-o anterior --%>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4 shadow-sm">
    <div class="container">
        <a class="navbar-brand fw-bold" href="LeagueStandings">🏆 RosterLeague</a>
        <div class="navbar-nav">
            <a class="nav-link" href="LeagueStandings">Clasamente</a>
            <a class="nav-link" href="AddMatch">Adaugă Meci</a>
        </div>
    </div>
</nav>

<div class="container py-4">
    <div class="text-center mb-5">
        <h1 class="display-5 fw-bold">Istoric Rezultate</h1>
        <p class="text-muted fs-4">Echipa: <span class="text-primary">${teamName}</span></p>
    </div>

    <div class="card match-card shadow border-0">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0 text-center">
                <thead class="table-dark">
                <tr>
                    <th class="text-end pe-5 py-3">Gazde</th>
                    <th style="width: 150px;">Scor Final</th>
                    <th class="text-start ps-5 py-3">Oaspeți</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${matches}" var="m">
                    <tr>
                            <%-- Evidențiem echipa selectată cu Bold și Albastru --%>
                        <td class="text-end pe-5 fs-5 ${m.homeTeam.name == teamName ? 'fw-bold text-primary' : ''}">
                                ${m.homeTeam.name}
                        </td>
                        <td>
                            <div class="score-box d-inline-block p-2 fw-bold fs-4">
                                    ${m.homeScore} - ${m.awayScore}
                            </div>
                        </td>
                        <td class="text-start ps-5 fs-5 ${m.awayTeam.name == teamName ? 'fw-bold text-primary' : ''}">
                                ${m.awayTeam.name}
                        </td>
                    </tr>
                </c:forEach>

                <%-- Mesaj în caz că lista e goală (cazul tău de acum) --%>
                <c:if test="${empty matches}">
                    <tr>
                        <td colspan="3" class="py-5">
                            <div class="text-muted">
                                <p class="mb-1">Nu am găsit meciuri salvate pentru <strong>${teamName}</strong>.</p>
                                <small>Asigură-te că ai adăugat meciuri în secțiunea "Adaugă Meci".</small>
                            </div>
                        </td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>

    <div class="mt-5 text-center">
        <a href="LeagueStandings" class="btn btn-outline-secondary btn-lg px-5 shadow-sm">
            ⬅ Înapoi la Clasament
        </a>
    </div>
</div>
</body>
</html>