/*

Queries used for Tableau Project

*/



-- 1. 

SELECT SUM(new_cases) AS total_cases, SUM(cast(new_deaths AS SIGNED)) AS total_deaths, SUM(cast(new_deaths AS SIGNED))/SUM(New_Cases)*100 AS DeathPercentage
FROM coviddeaths
WHERE location like '%states%'
GROUP BY `date`
ORDER BY DeathPercentage desc;

-- Just a double check based off the data provided
-- numbers are extremely close so we will keep them - The Second includes "International"  Location


Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as signed)) as total_deaths, SUM(cast(new_deaths as signed))/SUM(New_Cases)*100 as DeathPercentage
From coviddeaths
Where location like '%states%' and location = 'World'
Group By `date`
order by 1,2;


-- 2. 

-- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe

Select location, SUM(cast(new_deaths as signed)) as TotalDeathCount
From coviddeaths
Where location like '%states%' and continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc;


-- 3.

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From coviddeaths
Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc;


-- 4.


Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From coviddeaths
Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc;


-- Other Queries Analysis
-- 1.

Select dea.continent, dea.location, dea.`date`, dea.population
, MAX(vac.total_vaccinations) as RollingPeopleVaccinated
-- , (RollingPeopleVaccinated/population)*100
From coviddeaths dea
Join covidvaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
group by dea.continent, dea.location, dea.date, dea.population
order by 1,2,3;




-- 2.
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as signed)) as total_deaths, SUM(cast(new_deaths as signed))/SUM(New_Cases)*100 as DeathPercentage
From coviddeaths
Where location like '%states%' and 
continent is not null 
Group By `date`
order by 1,2;


-- Just a double check based off the data provided
-- numbers are extremely close so we will keep them - The Second includes "International"  Location


Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as signed)) as total_deaths, SUM(cast(new_deaths as signed))/SUM(New_Cases)*100 as DeathPercentage
From coviddeaths
Where location like '%states%' and 
location = 'World'
Group By `date`
order by 1,2;


-- 3.

-- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe

Select location, SUM(cast(new_deaths as signed)) as TotalDeathCount
From coviddeaths
Where location like '%states%' and 
continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc;



-- 4.

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From coviddeaths
Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc;



-- 5.

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From coviddeaths
Where location like '%states%' and 
continent is not null 
order by 1,2;

-- took the above query and added population
Select Location, date, population, total_cases, total_deaths
From coviddeaths
Where location like '%states%' and 
continent is not null 
order by 1,2;


-- 6. 


With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as signed)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
, (RollingPeopleVaccinated/population)*100
From coviddeaths dea
Join covidvaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100 as PercentPeopleVaccinated
From PopvsVac;


-- 7. 

Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From coviddeaths
Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc;




