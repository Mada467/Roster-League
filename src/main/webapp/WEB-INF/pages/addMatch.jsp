<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ro">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Adaugă Meci - Roster League</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
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
                    <a class="nav-link" href="${pageContext.request.contextPath}/TeamMatches">Meciuri Echipă</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="${pageContext.request.contextPath}/AddMatch">Adaugă Meci</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card shadow">
                <div class="card-header bg-primary text-white">
                    <h3 class="mb-0"><i class="bi bi-plus-circle"></i> Adaugă Meci Nou</h3>
                </div>
                <div class="card-body">

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="bi bi-exclamation-triangle-fill"></i> ${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <form method="post" action="${pageContext.request.contextPath}/AddMatch">

                        <!-- Selectare Ligă -->
                        <div class="mb-4">
                            <label for="leagueId" class="form-label fw-bold">
                                <i class="bi bi-list-ul"></i> Ligă
                            </label>
                            <select class="form-select" id="leagueId" name="leagueId" required>
                                <option value="">-- Selectează Liga --</option>
                                <c:forEach items="${leagues}" var="league">
                                    <option value="${league.id}">${league.name}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <!-- Echipa Gazdă -->
                        <div class="mb-4">
                            <label for="homeTeamId" class="form-label fw-bold">
                                <i class="bi bi-house-fill"></i> Echipa Gazdă
                            </label>
                            <select class="form-select" id="homeTeamId" name="homeTeamId" required>
                                <option value="">-- Selectează Echipa Gazdă --</option>
                                <c:forEach items="${teams}" var="team">
                                    <option value="${team.id}">${team.name}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <!-- Scor Gazdă -->
                        <div class="mb-4">
                            <label for="homeScore" class="form-label fw-bold">
                                <i class="bi bi-hash"></i> Goluri Gazdă
                            </label>
                            <input type="number" class="form-control" id="homeScore" name="homeScore"
                                   min="0" max="50" required placeholder="Ex: 2">
                        </div>

                        <!-- Echipa Oaspete -->
                        <div class="mb-4">
                            <label for="awayTeamId" class="form-label fw-bold">
                                <i class="bi bi-airplane-fill"></i> Echipa Oaspete
                            </label>
                            <select class="form-select" id="awayTeamId" name="awayTeamId" required>
                                <option value="">-- Selectează Echipa Oaspete --</option>
                                <c:forEach items="${teams}" var="team">
                                    <option value="${team.id}">${team.name}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <!-- Scor Oaspete -->
                        <div class="mb-4">
                            <label for="awayScore" class="form-label fw-bold">
                                <i class="bi bi-hash"></i> Goluri Oaspete
                            </label>
                            <input type="number" class="form-control" id="awayScore" name="awayScore"
                                   min="0" max="50" required placeholder="Ex: 1">
                        </div>

                        <!-- Butoane -->
                        <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                            <a href="${pageContext.request.contextPath}/LeagueStandings"
                               class="btn btn-secondary">
                                <i class="bi bi-x-circle"></i> Anulează
                            </a>
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-save"></i> Salvează Meciul
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>