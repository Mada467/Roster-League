<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ro">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Clasament Ligă - Roster League</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        .top-3 { background-color: #fff3cd; }
        .medal-gold { color: #ffd700; }
        .medal-silver { color: #c0c0c0; }
        .medal-bronze { color: #cd7f32; }
    </style>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/">
            <i class="bi bi-trophy-fill"></i> Roster League
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item">
                    <a class="nav-link active" href="${pageContext.request.contextPath}/LeagueStandings">Clasamente</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/TeamMatches">Meciuri Echipă</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/AddMatch">Adaugă Meci</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<div class="container mt-5">
    <div class="row">
        <div class="col-12">
            <div class="card shadow">
                <div class="card-header bg-primary text-white">
                    <h3 class="mb-0"><i class="bi bi-bar-chart-fill"></i> Clasament Ligă</h3>
                </div>
                <div class="card-body">

                    <c:if test="${param.success eq 'true'}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="bi bi-check-circle-fill"></i> Meciul a fost adăugat cu succes!
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <!-- Formular selectare ligă -->
                    <form method="get" action="${pageContext.request.contextPath}/LeagueStandings" class="mb-4">
                        <div class="row align-items-end">
                            <div class="col-md-8">
                                <label for="leagueId" class="form-label fw-bold">
                                    <i class="bi bi-list-ul"></i> Selectează Liga
                                </label>
                                <select class="form-select" id="leagueId" name="leagueId"
                                        onchange="this.form.submit()">
                                    <option value="">-- Alege o ligă --</option>
                                    <c:forEach items="${leagues}" var="league">
                                        <option value="${league.id}"
                                            ${selectedLeague.id eq league.id ? 'selected' : ''}>
                                                ${league.name}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <button type="submit" class="btn btn-primary w-100">
                                    <i class="bi bi-search"></i> Afișează Clasament
                                </button>
                            </div>
                        </div>
                    </form>

                    <!-- Clasament -->
                    <c:if test="${not empty selectedLeague}">
                        <div class="mb-3">
                            <h4 class="text-center">
                                <i class="bi bi-trophy"></i> ${selectedLeague.name}
                            </h4>
                        </div>

                        <c:choose>
                            <c:when test="${not empty standings}">
                                <div class="table-responsive">
                                    <table class="table table-hover table-striped">
                                        <thead class="table-dark">
                                        <tr>
                                            <th width="5%">Poz</th>
                                            <th width="35%">Echipă</th>
                                            <th width="8%" class="text-center">M</th>
                                            <th width="8%" class="text-center">V</th>
                                            <th width="8%" class="text-center">E</th>
                                            <th width="8%" class="text-center">Î</th>
                                            <th width="8%" class="text-center">GM</th>
                                            <th width="8%" class="text-center">GP</th>
                                            <th width="8%" class="text-center">GD</th>
                                            <th width="8%" class="text-center fw-bold">Pct</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <c:forEach items="${standings}" var="standing" varStatus="status">
                                            <tr class="${status.index < 3 ? 'top-3' : ''}">
                                                <td class="fw-bold">
                                                    <c:choose>
                                                        <c:when test="${status.index == 0}">
                                                            <i class="bi bi-trophy-fill medal-gold"></i> ${status.index + 1}
                                                        </c:when>
                                                        <c:when test="${status.index == 1}">
                                                            <i class="bi bi-trophy-fill medal-silver"></i> ${status.index + 1}
                                                        </c:when>
                                                        <c:when test="${status.index == 2}">
                                                            <i class="bi bi-trophy-fill medal-bronze"></i> ${status.index + 1}
                                                        </c:when>
                                                        <c:otherwise>
                                                            ${status.index + 1}
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="fw-bold">${standing.teamName}</td>
                                                <td class="text-center">${standing.matchesPlayed}</td>
                                                <td class="text-center">${standing.wins}</td>
                                                <td class="text-center">${standing.draws}</td>
                                                <td class="text-center">${standing.losses}</td>
                                                <td class="text-center">${standing.goalsFor}</td>
                                                <td class="text-center">${standing.goalsAgainst}</td>
                                                <td class="text-center ${standing.goalDifference > 0 ? 'text-success' : standing.goalDifference < 0 ? 'text-danger' : ''}">
                                                        ${standing.goalDifference > 0 ? '+' : ''}${standing.goalDifference}
                                                </td>
                                                <td class="text-center fw-bold text-primary">${standing.points}</td>
                                            </tr>
                                        </c:forEach>
                                        </tbody>
                                    </table>
                                </div>

                                <div class="mt-3">
                                    <small class="text-muted">
                                        <strong>Legendă:</strong>
                                        M = Meciuri jucate | V = Victorii | E = Egaluri | Î = Înfrângeri |
                                        GM = Goluri marcate | GP = Goluri primite | GD = Golaveraj | Pct = Puncte
                                    </small>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="alert alert-info text-center">
                                    <i class="bi bi-info-circle"></i> Nu există meciuri înregistrate pentru această ligă.
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </c:if>

                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>