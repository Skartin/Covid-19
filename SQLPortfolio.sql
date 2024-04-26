/*

Covid 19 Data Exploration 

Skills used: Joins, Aggregate Functions, Creating Views, Converting Data Types

*/

-- Total Cases vs Total Deaths vs total vaccinations
Select Location, date, total_cases, total_vaccinations
From SQLPortfolio..CovidDeaths
Where continent is not null 
order by 1,2


-- Total Cases vs Population
Select Location, date, Population, total_cases
From SQLPortfolio..CovidDeaths
order by 1,2


-- Countries with Lowest Death Count per Population
Select Location, MIN(cast(Total_deaths as int)) as TotalDeathCount
From SQLPortfolio..CovidDeaths
--Where location like '%states%'
Where continent is not null 
Group by Location
order by TotalDeathCount desc

-- Showing contintents with the highest death count per population
Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From SQLPortfolio..CovidDeaths
Where continent is not null 
Group by continent
order by TotalDeathCount desc


-- Creating View to store data for visualizations
Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From SQLPortfolio..CovidDeaths dea
Join SQLPortfolio..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 

	
-- GLOBAL NUMBERS
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From SQLPortfolio..CovidDeaths
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2


--Retrieve the total cases, total tests, and date for both vaccinations and deaths that occurred on the same date.
SELECT 
    d.total_cases, 
    v.total_tests,
    v.date
FROM 
    CovidVanccinations v
JOIN 
    coviddeaths d ON v.date = d.date;


-- Total Population vs Vaccinations by Country
SELECT
	dea.continent AS Continent, 
	dea.location AS Country, 
	dea.population AS Population, 
	vac.total_vaccinations AS Vaccination
FROM 
	CovidDeaths dea
JOIN 
	CovidVaccinations vac ON dea.location = vac.location
WHERE 
	dea.continent IS NOT NULL 
GROUP BY 
	1,2
