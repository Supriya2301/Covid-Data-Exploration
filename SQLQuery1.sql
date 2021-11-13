select * from
CovidAnalysisProject..CovidVaccinations
where continent is not null
order by 3,4

SELECT Location, date,total_cases,new_cases,total_deaths, population
from
CovidAnalysisProject..CovidDeaths
order by 1,2

-- Total cases vs Totals deaths in India
SELECT Location, date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from
CovidAnalysisProject..CovidDeaths
where location like 'India'
order by 1,2

-- Percentage of people got covid
SELECT Location, date,Population, total_cases, (total_cases/Population)*100 as PeopleAffected
from
CovidAnalysisProject..CovidDeaths
where Location like 'India'
order by 1,2

-- highestnumberofcases compared to Population
SELECT Location,Population, max(total_cases) as MaxCasesFound, max((total_cases/Population))*100 as PeopleAffected
from
CovidAnalysisProject..CovidDeaths
group by Location,Population
order by PeopleAffected desc


-- maximum deaths across different countries

select Location,max(cast(total_deaths as int)) as MaxDeathCount
from 
CovidAnalysisProject..CovidDeaths
where continent is not null
group by location
order by MaxDeathCount desc

select location,max(cast(total_deaths as int)) as MaxDeathCount
from 
CovidAnalysisProject..CovidDeaths
where continent is  null
group by location
order by MaxDeathCount desc


-- total cases  and total deaths and deathPercentage worldwide

select sum(new_cases) as total_cases,sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from CovidAnalysisProject..CovidDeaths
where continent is not null
order by 1,2

-- Total Population vs Vaccinations

with PopvsVac (Continent, Location, date, population,New_Vaccinations, RollingPeopleVaccinated)--,PercentageVaccinated)
as
(
select d.continent, d.location,d.date, d.population,v.new_vaccinations,
sum(cast(v.new_vaccinations as int)) over (Partition by d. location order by d.location,
d.date) as RollingPeopleVaccinated --,(RollingPeopleVaccinated/population)*100

from CovidAnalysisProject..CovidDeaths d
join CovidAnalysisProject..CovidVaccinations v
on d.location = v.location
and d.date = v.date
where d.continent is not null --and d.location like 'India'
--order by 2,3
)
select * from PopvsVac


--	queries for Tableau

-- 1.



Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From CovidAnalysisProject..CovidDeaths
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


-- 2. 

-- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From CovidAnalysisProject..CovidDeaths
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc


-- 3.

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From CovidAnalysisProject..CovidDeaths
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc


-- 4.


Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From CovidAnalysisProject..CovidDeaths
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc











