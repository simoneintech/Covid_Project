# Covid-19 Project

In this repository I have completed a project on COVID-19 <br />
from the years of 2019-2021. I wanted to understand how COVID-19 <br />
have effected the world globally. 

# <b> How I Started </b><br />
First, I got my dataset from <a href="data.gov">Data.gov</a>. Downloaded 
this data as a CSV file to do some data cleaning over in Excel. 

<br />
In excel I anazlyzed my data, wanted to see what information was provdied. <br />
Got myself familiar with the dataset and went into cleaning my data. 

I cleaned up some of the columns with the information I needed for SQL.
I then created two different worksheets for Vaccinations and one
for Deaths. <br />
With this I would be able to analyze my data more clearly in SQL using two
tables to further help with my analysis. 

# <b> Questions Asked </b>

<ul>
  <li>What is the likelihood of dying if contracted COVID-19?</li>
  <li>What percentage of the US has gotten COVID-19</li>
  <li>Which countries has the highest infection rate per population?</li>
  <li>What continents has the highest death count per population?</li>
  <li>How many have been vaccinated globally?</li>

# <b> Queries to Answer Questions Asked </b>

<b> What is the likelihood of dying if contracted COVID-19? </b>
<b><u>Query</b></u>: <br />
SELECT Location, Date, Total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM CovidProject..CovidDeaths
WHERE location like '%states%'
AND continent is not null
Order by 1,2

<b> What percentage of the US has gotten COVID-19?</b>
<b><u>Query</b></u>: <br />
SELECT Location, Date, population, Total_cases, (total_cases/population)*100 as CovidPercentage
FROM CovidProject..CovidDeaths
WHERE location like '%states%'
AND continent is not null
Order by 1,2

<b>Which countries has the highest infection rate per population?
<b><u>Query</b></u>: <br />

SELECT Location, population, MAX(Total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as InfectedPopulationPercentage
FROM CovidProject..CovidDeaths
--WHERE location like '%states%'
where continent is not null
Group by Location, Population
Order by InfectedPopulationPercentage desc
<br />
<b>What continents has the highest death count per population?</b>
<b><u>Query</b></u>: <br />
SELECT Location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM CovidProject..CovidDeaths
--WHERE location like '%states%'
Where continent is not null
Group by Location
Order by TotalDeathCount desc
  <br />
  
<b>What continents has the highest death count per population?</b>
<b><u>Query</b></u>: <br />
SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM CovidProject..CovidDeaths
--WHERE location like '%states%'
Where continent is not null
Group by continent
Order by TotalDeathCount desc

<br />
<b>How many have been vaccinated globally?</b>
<b><u>Query</b></u>: <br />

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

# <b>Problems I Came Across</b>
In the table, some continents were labeled as countries, and some continents were null. This was causing me
to have an inaccurate analysis. I solved this problem, by using applying 
"where continent is not null" that way, I can then seperate continents that were labeled as countries, as well
as any null data within my tables, allowing for a more accurate analysis. 
