-- All Data from COVID-19 Deaths Table

SELECT * FROM coviddeaths;

-- All Data from COVID-19 Vaccination Table

SELECT * FROM covidvaccinations;

-- Data from COVID-19 Deaths Table
-- Showing location, date, total cases, and population from COVID-19 deaths table

SELECT location, `date`, total_cases, 
new_cases, total_cases, total_deaths, 
population FROM coviddeaths;

-- Total Cases vs Total Deaths

SELECT location, `date`, total_cases, 
total_deaths, (total_deaths/total_cases) * 100 AS _percentage_death_cases_
FROM coviddeaths
where location = 'Canada'
ORDER BY total_deaths DESC;

-- Total Cases vs Population
-- Shows percentage of COVID-19 Cases 

SELECT location, `date`, total_cases, population, 
(total_cases / population) * 100 AS _percentage_total_cases_
FROM coviddeaths
where location = 'Nigeria';

-- Higest COVID-19 Infection Rate Per Country
-- Showing the Highest Percentage of COVID-19 infection rate

SELECT location, population, MAX(total_cases) AS highest_COVID19_cases,  
MAX((total_cases / population)) * 100 AS _percentage_total_cases_
FROM coviddeaths
GROUP BY location,  population
order by _percentage_total_cases_ DESC;

-- Higest COVID-19 Death Rate Per Country
-- Showing the Highest Percentage of COVID-19 death rate

SELECT location, population, MAX(CAST(total_deaths AS SIGNED)) AS highest_COVID19_deaths
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY location,  population
ORDER BY highest_COVID19_deaths DESC;

-- Analysis by Continent Highest Death Rate

SELECT continent, MAX(CAST(total_deaths AS SIGNED)) AS highest_COVID19_deaths
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY highest_COVID19_deaths DESC;

-- Global COVID-19  by Continent

SELECT continent, SUM(CAST(total_cases AS SIGNED)) AS total_cases 
FROM coviddeaths
GROUP BY continent
ORDER BY total_cases DESC;

-- Global COVID-19 total casses and death cses by date (day)

SELECT `date`, SUM(CAST(new_cases AS SIGNED)) AS total_cases, 
SUM(CAST(new_deaths AS SIGNED)) AS total_deaths,
(SUM(CAST(new_deaths AS SIGNED)) / SUM(CAST(new_cases AS SIGNED))) * 100 AS _percentage_global_cases
FROM coviddeaths
GROUP BY `date`
ORDER BY total_cases ASC;

-- Global COVID-19 total cases by location (country)

SELECT location, SUM(CAST(new_cases AS SIGNED)) AS total_cases 
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY total_cases DESC;

-- Joining both tables (COVID-19 deaths and COVID-19 Vaccinations)

SELECT dea.location, dea.continent, dea.`date`,
dea.population, vac.new_vaccinations, SUM(CAST(new_vaccinations AS SIGNED)) 
OVER(PARTITION BY dea.location ORDER BY dea.location, dea.`date`) AS _rolling_vaccinated_people_
 FROM coviddeaths dea
JOIN covidvaccinations vac
ON dea.location = vac.location AND
dea.`date` = vac.`date`;

-- Gropuing by location

SELECT dea.location, dea.continent, 
dea.population, SUM(CAST(vac.new_vaccinations AS SIGNED)) AS vaccinations FROM coviddeaths dea
JOIN covidvaccinations vac
ON dea.location = vac.location AND
dea.`date` = vac.`date`
GROUP BY dea.location, dea.continent, 
dea.population
ORDER BY vaccinations DESC;

-- Pecentage of vaccination vs population 

WITH population_vaccination  AS 
(SELECT dea.location, dea.continent, dea.`date`,
dea.population, vac.new_vaccinations, SUM(CAST(new_vaccinations AS SIGNED)) 
OVER(PARTITION BY dea.location ORDER BY dea.location, dea.`date`) AS _rolling_vaccinated_people_
 FROM coviddeaths dea
JOIN covidvaccinations vac
ON dea.location = vac.location AND
dea.`date` = vac.`date`)
SELECT *, (_rolling_vaccinated_people_ / population) * 100 AS _percentage_of_vacc_popu_ 
FROM Population_vaccination;
-- ORDER BY _percentage_of_vacc_popu_ DESC ;

-- Temp Table 

DROP TABLE _percentage_population_vaccinated;
CREATE TABLE _percentage_population_vaccinated
(
location nvarchar(255), 
continent nvarchar(255), 
`date` datetime,
population int, 
new_vaccinations int,
_rolling_vaccinated_people_ int
)

INSERT INTO _percentage_population_vaccinated
SELECT dea.location, dea.continent, dea.`date`,
dea.population, vac.new_vaccinations, SUM(CAST(new_vaccinations AS SIGNED)) 
OVER(PARTITION BY dea.location ORDER BY dea.location, dea.`date`) AS _rolling_vaccinated_people_
 FROM coviddeaths dea
JOIN covidvaccinations vac
ON dea.location = vac.location AND
dea.`date` = vac.`date`

SELECT *, (_rolling_vaccinated_people_ / population) * 100 AS _percentage_of_vacc_popu_ 
FROM _percentage_population_vaccinated);

CREATE VIEW percentage_population_vaccinated AS 
SELECT dea.locapercentage_population_vaccinated_rolling_vaccinated_people_percentage_population_vaccinatedpercentage_population_vaccinatedtion, dea.continent, dea.`date`,
dea.population, vac.new_vaccinations, SUM(CAST(new_vaccinations AS SIGNED)) 
OVER(PARTITION BY dea.location ORDER BY dea.location, dea.`date`) AS _rolling_vaccinated_people_
 FROM coviddeaths dea
JOIN covidvaccinations vac
ON dea.location = vac.location AND
dea.`date` = vac.`date`


