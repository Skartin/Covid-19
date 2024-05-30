-- Covid 19 Data Exploration -- Skills used: Joins, Aggregate Functions, Creating Views, Converting Data Types


-- Total Cases vs Total Deaths vs total vaccinations
SELECT 
    Location,
    date,
    total_cases,
    total_vaccinations
FROM 
    covid-19..CovidDeaths
WHERE 
    continent IS NOT NULL
ORDER BY 
    1, 2;

---------------------------------------------------------------
-- Query to retrieve daily new cases for The United States:
SELECT DISTINCT
    date,
    new_cases
FROM 
    CovidDeaths
WHERE 
    location = 'United States'
ORDER BY 
    date;

---------------------------------------------------------------
-- Total Cases vs Population
SELECT 
    Location,
    Date,
    Population,
    total_cases
FROM 
    covid-19..CovidDeaths
ORDER BY 
    1, 2;

---------------------------------------------------------------
-- Countries with Lowest Death Count per Population
SELECT 
    Location,
    MIN(CAST(Total_deaths AS INT)) AS TotalDeathCount
FROM 
    covid-19..CovidDeaths
WHERE 
    continent IS NOT NULL
GROUP BY 
    Location
ORDER BY 
    TotalDeathCount DESC;

---------------------------------------------------------------
-- Showing contintents with the highest death count per population
SELECT 
    continent,
    MAX(CAST(Total_deaths AS INT)) AS TotalDeathCount
FROM 
    covid-19..CovidDeaths
WHERE 
    continent IS NOT NULL
GROUP BY 
    continent
ORDER BY 
    TotalDeathCount DESC;

---------------------------------------------------------------
-- Creating View to store data for visualizations
CREATE VIEW PercentPopulationVaccinated AS
SELECT 
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    SUM(CONVERT(INT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM 
    covid-19..CovidDeaths dea
JOIN 
    covid-19..CovidVaccinations vac ON dea.location = vac.location AND dea.date = vac.date
WHERE 
    dea.continent IS NOT NULL;

---------------------------------------------------------------
-- GLOBAL NUMBERS
SELECT 
    SUM(new_cases) AS total_cases,
    SUM(CAST(new_deaths AS INT)) AS total_deaths,
    SUM(CAST(new_deaths AS INT)) / SUM(new_cases) * 100 AS DeathPercentage
FROM 
    covid-19..CovidDeaths
WHERE 
    continent IS NOT NULL
ORDER BY 
    1, 2;

---------------------------------------------------------------
--Retrieve the total deaths by country
SELECT 
    d.location AS country,
    SUM(d.new_deaths) AS total_deaths
FROM 
    coviddeaths d
WHERE 
    d.continent IS NOT NULL 
GROUP BY 
    d.location;

---------------------------------------------------------------
-- Total Population vs Vaccinations by Country
SELECT
    vac.continent AS Continent,
    vac.location AS Country,
    vac.total_vaccinations AS Vaccination
FROM 
    CovidVaccinations vac
WHERE 
    vac.continent IS NOT NULL  
    AND vac.date = '4/30/21'
GROUP BY 
    vac.location;

