SELECT *
FROM PortfolioProject.dbo.CovidDeaths
where continent is not null
order by 3,4



select location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject.dbo.CovidDeaths
where continent is not null
order by 1,2

-- Looking at Total Cases vs Total Deaths
-- shows the likelihood of dying if you contract covid in your country
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
FROM PortfolioProject.dbo.CovidDeaths
where location like '%states%'
AND continent is not null
order by 1,2

-- Looking at Total Cases vs population

SELECT Location, date, total_cases, population, (total_cases/population)*100 as Covid_diagnosed_percentage
FROM PortfolioProject.dbo.CovidDeaths
where location like '%states%'
order by 1,2

-- Looking at countries with highest Infection rate compared to population

SELECT Location, population, MAX(total_cases) as Highest_Infection_Count, Max((total_cases/population))*100 as Covid_diagnosed_percentage
FROM PortfolioProject.dbo.CovidDeaths
group by location, population
order by Covid_diagnosed_percentage desc


-- Countries with the highest death count per population


SELECT Location, MAX(cast(total_deaths as int)) as total_death_count
FROM PortfolioProject.dbo.CovidDeaths
where continent is not null
group by location
order by total_death_count desc

-- BREAK DOWN BY CONTINENT

SELECT location, MAX(cast(total_deaths as int)) as total_death_count
FROM PortfolioProject.dbo.CovidDeaths
where continent is null
group by location
order by total_death_count desc


-- showing continents with the highest death count per population

SELECT continent, MAX(cast(total_deaths as int)) as total_death_count
FROM PortfolioProject.dbo.CovidDeaths
where continent is not null
group by continent
order by total_death_count desc


-- Global Numbers

SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, 
SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM PortfolioProject.dbo.CovidDeaths
where continent is not null
--group by date
order by 1,2


-- Total Population vs Vaccinations
WITH PopvsVac (continent, location, date, population, new_vaccinations, Rolling_Vaccinations)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.Location, 
	dea.date) as Rolling_Vaccinations
	--, (Rolling_Vaccinations/population)*100
From PortfolioProject.dbo.CovidDeaths dea
JOIN PortfolioProject.dbo.CovidVaccinations vac
	on dea.location = vac.location
	AND dea.date = vac.date
Where dea.continent is not null
--Order by 2,3
)
select *, (Rolling_Vaccinations/Population)*100
From PopvsVac

--Temp Table
DROP TABLE if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
	continent nvarchar(255)
  , Location nvarchar(255)
  , Date datetime
  , Population numeric
  , New_vaccination numeric
  , Rolling_Vaccinations numeric
)

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.Location, 
	dea.date) as Rolling_Vaccinations
	--, (Rolling_Vaccinations/population)*100
From PortfolioProject.dbo.CovidDeaths dea
JOIN PortfolioProject.dbo.CovidVaccinations vac
	on dea.location = vac.location
	AND dea.date = vac.date
Where dea.continent is not null
--Order by 2,3

select *, (Rolling_Vaccinations/Population)*100
From #PercentPopulationVaccinated

-- Creating view to store data for later visulization

create view PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.Location, 
	dea.date) as Rolling_Vaccinations
	--, (Rolling_Vaccinations/population)*100
From PortfolioProject.dbo.CovidDeaths dea
JOIN PortfolioProject.dbo.CovidVaccinations vac
	on dea.location = vac.location
	AND dea.date = vac.date
Where dea.continent is not null
--Order by 2,3

select *
From PercentPopulationVaccinated