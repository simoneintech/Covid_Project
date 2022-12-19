SELECT *
From CovidProject..CovidDeaths
where continent is not null
Order By 3,4

-- added continent is not null for continents in the table
-- that are labeled as continents where they should be labeled
-- as countries instead. 

--SELECT *
--From CovidProject..CovidVaccinations
--Order By 3,4

-- Data I will be using

SELECT Location, Date, Total_cases, new_cases, total_deaths, population
FROM CovidProject..CovidDeaths
where continent is not null
Order by 1,2

-- Looking at Total Cases vs Total Deaths
-- shows the likelihood of dying if you attract covid in United States 

SELECT Location, Date, Total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM CovidProject..CovidDeaths
WHERE location like '%states%'
AND continent is not null
Order by 1,2


-- Loooking at the Total Cases vs Population
-- Shows what percentage of the United States has gotten Covid

SELECT Location, Date, population, Total_cases, (total_cases/population)*100 as CovidPercentage
FROM CovidProject..CovidDeaths
WHERE location like '%states%'
AND continent is not null
Order by 1,2

--  looking at countries with highest infection rate compared to Population 

SELECT Location, population, MAX(Total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as InfectedPopulationPercentage
FROM CovidProject..CovidDeaths
--WHERE location like '%states%'
where continent is not null
Group by Location, Population
Order by InfectedPopulationPercentage desc

-- Showing countries with highest death count per population 

SELECT Location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM CovidProject..CovidDeaths
--WHERE location like '%states%'
Where continent is not null
Group by Location
Order by TotalDeathCount desc

-- breaking things down by continent 

SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM CovidProject..CovidDeaths
--WHERE location like '%states%'
Where continent is not null
Group by continent
Order by TotalDeathCount desc

-- data above is only showing data in North America for the United States
-- no data is being calculated with other North American countries

-- shows proper count now for all continents

SELECT location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM CovidProject..CovidDeaths
--WHERE location like '%states%'
Where continent is null
Group by location
Order by TotalDeathCount desc

-- showing continents with highest
-- death count per population
-- for drill down effect in tableau 

SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM CovidProject..CovidDeaths
--WHERE location like '%states%'
Where continent is not null
Group by continent
Order by TotalDeathCount desc

-- global calculations for 
-- death percentage per population
-- per day 

SELECT Date, sum(new_cases) as total_cases, sum(cast (new_deaths as int)) as total_deaths, 
SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM CovidProject..CovidDeaths
--WHERE location like '%states%'
where continent is not null
Group by Date 
Order by 1,2

-- global calculations for
-- death percentages per populatoin
-- as a whole

SELECT sum(new_cases) as total_cases, sum(cast (new_deaths as int)) as total_deaths, 
SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM CovidProject..CovidDeaths
--WHERE location like '%states%'
where continent is not null
--Group by Date 
Order by 1,2


-- looking at total population vs vaccinations
-- how many people globally have been vaccinated?

SELECT *
From CovidProject..CovidVaccinations vac
Join CovidProject..CovidDeaths dea
	on dea.location = vac.location
	and dea.date = vac.date

SELECT dea.continent, dea.location, dea.date, vac.population, dea.new_vaccinations
, SUM(convert(int,dea.new_vaccinations)) OVER (partition by  dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated 
--, (rollingpeoplevaccinated/population)*100
From CovidProject..CovidVaccinations dea
Join CovidProject..CovidDeaths vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent  is not null
order by 2,3

-- USE CTE

with PopvsVac (continent, location, date, population, New_vaccinations, RollingPeopleVaccinated)
as 
(
SELECT dea.continent, dea.location, dea.date, vac.population, dea.new_vaccinations
, SUM(convert(int,dea.new_vaccinations)) OVER (partition by  dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated 
--, (RollingPeopleVaccinated/population)*100
From CovidProject..CovidVaccinations dea
Join CovidProject..CovidDeaths vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent  is not null
--order by 2,3
)
SELECT *, (RollingPeopleVaccinated/Population)*100 as VacPercentage 
From PopvsVac 

-- Temp Table

DROP Table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, vac.population, dea.new_vaccinations
, SUM(convert(int,dea.new_vaccinations)) OVER (partition by  dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated 
--, (rollingpeoplevaccinated/population)*100
From CovidProject..CovidVaccinations dea
Join CovidProject..CovidDeaths vac
	on dea.location = vac.location
	and dea.date = vac.date
--where dea.continent  is not null
--order by 2,3

SELECT *, (RollingPeopleVaccinated/Population)*100 as VacPercentage 
From #PercentPopulationVaccinated



-- creating view to store data 
-- for later visualizations

Create View PercentPopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, vac.population, dea.new_vaccinations
, SUM(convert(int,dea.new_vaccinations)) OVER (partition by  dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated 
--, (rollingpeoplevaccinated/population)*100
From CovidProject..CovidVaccinations dea
Join CovidProject..CovidDeaths vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent  is not null
--order by 2,3


/*
Queries used for Tableau Project
*/

-- table 1 

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From CovidProject..CovidDeaths
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2

-- Just a double check based off the data provided
-- numbers are extremely close so we will keep them - The Second includes "International"  Location


--Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
--From PortfolioProject..CovidDeaths
----Where location like '%states%'
--where location = 'World'
----Group By date
--order by 1,2


-- table 2. 

-- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From CovidProject..CovidDeaths
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc


-- table 3

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From CovidProject..CovidDeaths
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc


-- table 4

Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From CovidProject..CovidDeaths
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc

