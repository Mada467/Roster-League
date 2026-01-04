<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ro">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Meciuri Echipă - Roster League</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        .match-card {
            border-left: 5px solid #0d6efd;
            margin-bottom: 15px;
        }
        .match-win { border-left-color: #198754; }
        .match-draw { border-left-color: #ffc107; }
        .match-loss { border-left-color: #dc3545; }
        .score-large {
            font-size: 2rem;
            font-weight: bold;
        }
        .team-home { color: #0d6efd; }
        .team-away { color: #6c757d; }
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
                    <a class="nav-link" href="${pageContext.request.contextPath}/LeagueStandings">Clasamente</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="${pageContext.request.contextPath}/TeamMatches">Meciuri Echipă</a>
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
                    <h3 class="mb-0"><i class="bi bi-calendar-event"></i> Meciuri Echipă</h3>
                </div>
                <div class="card-body">

                    <!-- Formular selectare echipă -->
                    <form method="get" action="${pageContext.request.contextPath}/TeamMatches" class="mb-4">
                        <div class="row align-items-end">
                            <div class="col-md-8">
                                <label for="teamId" class="form-label fw-bold">
                                    <i class="bi bi-people-fill"></i> Selectează Echipa
                                </label>
                                <select class="form-select" id="teamId" name="teamId"
                                        onchange="this.form.submit()">
                                    <option value="">-- Alege o echipă --</option>
                                    <c:forEach items="${teams}" var="team">
                                        <option value="${team.id}"
                                            ${selectedTeam.id eq team.id ? 'selected' : ''}>
                                                ${team.name}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <button type="submit" class="btn btn-primary w-100">
                                    <i class="bi bi-search"></i> Afișează Meciuri
                                </button>
                            </div>
                        </div>
                    </form>

                    <!-- Statistici și Meciuri -->
                    <c:if test="${not empty selectedTeam}">

                        <!-- Statistici Generale -->
                        <div class="row mb-4">
                            <div class="col-12">
                                <div class="alert alert-info">
                                    <h4 class="alert-heading">
                                        <i class="bi bi-bar-chart-fill"></i> Statistici ${selectedTeam.name}
                                    </h4>
                                    <div class="row text-center mt-3">
                                        <div class="col-md-2">
                                            <div class="card">
                                                <div class="card-body">
                                                    <h5 class="card-title">${totalMatches}</h5>
                                                    <p class="card-text text-muted small">Meciuri</p>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <div class="card border-success">
                                                <div class="card-body">
                                                    <h5 class="card-title text-success">${wins}</h5>
                                                    <p class="card-text text-muted small">Victorii</p>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <div class="card border-warning">
                                                <div class="card-body">
                                                    <h5 class="card-title text-warning">${draws}</h5>
                                                    <p class="card-text text-muted small">Egaluri</p>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <div class="card border-danger">
                                                <div class="card-body">
                                                    <h5 class="card-title text-danger">${losses}</h5>
                                                    <p class="card-text text-muted small">Înfrângeri</p>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <div class="card">
                                                <div class="card-body">
                                                    <h5 class="card-title">${goalsFor} - ${goalsAgainst}</h5>
                                                    <p class="card-text text-muted small">Goluri</p>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <div class="card border-primary">
                                                <div class="card-body">
                                                    <h5 class="card-title text-primary fw-bold">${points}</h5>
                                                    <p class="card-text text-muted small">Puncte</p>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Lista Meciuri -->
                        <h5 class="mb-3"><i class="bi bi-list-ul"></i> Istoric Meciuri</h5>

                        <c:choose>
                            <c:when test="${not empty matches}">
                                <c:forEach items="${matches}" var="match">
                                    <c:set var="isHome" value="${match.homeTeam.id eq selectedTeam.id}" />
                                    <c:set var="teamGoals" value="${isHome ? match.homeScore : match.awayScore}" />
                                    <c:set var="opponentGoals" value="${isHome ? match.awayScore : match.homeScore}" />
                                    <c:set var="opponent" value="${isHome ? match.awayTeam : match.homeTeam}" />
                                    <c:set var="result" value="${teamGoals > opponentGoals ? 'win' : teamGoals == opponentGoals ? 'draw' : 'loss'}" />

                                    <div class="card match-card match-${result}">
                                        <div class="card-body">
                                            <div class="row align-items-center">
                                                <div class="col-md-3 text-center">
                                                        <span class="badge ${result == 'win' ? 'bg-success' : result == 'draw' ? 'bg-warning' : 'bg-danger'}">
                                                                ${isHome ? 'ACASĂ' : 'DEPLASARE'}
                                                        </span>
                                                    <div class="mt-2">
                                                        <small class="text-muted">${match.league.name}</small>
                                                    </div>
                                                </div>
                                                <div class="col-md-6 text-center">
                                                    <div class="row align-items-center">
                                                        <div class="col-5">
                                                            <h5 class="mb-0 ${isHome ? 'fw-bold' : ''}">${match.homeTeam.name}</h5>
                                                        </div>
                                                        <div class="col-2">
                                                                <span class="score-large ${result == 'win' ? 'text-success' : result == 'draw' ? 'text-warning' : 'text-danger'}">
                                                                    ${match.homeScore} - ${match.awayScore}
                                                                </span>
                                                        </div>
                                                        <div class="col-5">
                                                            <h5 class="mb-0 ${!isHome ? 'fw-bold' : ''}">${match.awayTeam.name}</h5>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col-md-3 text-center">
                                                    <c:choose>
                                                        <c:when test="${result == 'win'}">
                                                            <h4><i class="bi bi-check-circle-fill text-success"></i></h4>
                                                            <span class="badge bg-success">VICTORIE (+3 pct)</span>
                                                        </c:when>
                                                        <c:when test="${result == 'draw'}">
                                                            <h4><i class="bi bi-dash-circle-fill text-warning"></i></h4>
                                                            <span class="badge bg-warning">EGAL (+1 pct)</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <h4><i class="bi bi-x-circle-fill text-danger"></i></h4>
                                                            <span class="badge bg-danger">ÎNFRÂNGERE (0 pct)</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="alert alert-info text-center">
                                    <i class="bi bi-info-circle"></i> Această echipă nu a jucat niciun meci încă.
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