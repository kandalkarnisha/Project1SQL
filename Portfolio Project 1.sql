select * from coviddeaths
Where continent is not null
order by 3, 4

select * from CovidVaccinations
order by 3, 4

select location, date, total_cases, new_cases total_deaths, population
from CovidDeaths
order by 1, 2

--looking at Total cases vs Total deaths
--shows likelyhood of dying if you contract covid in your country

select location, date, total_cases, new_cases total_deaths, (total_deaths/total_cases)*100 as Death_Percentages
from CovidDeaths
Where location like '%states%' AND
 continent is not null
order by 1, 2

--Looking at Total cases vs Population 
--Shows what percentage got Covid


select location, date, population, total_cases, new_cases total_deaths, (total_cases/population)*100 as PercentagePopulationInfected
from CovidDeaths
--Where location like '%states%'
order by 1, 2

--Looking at the countries with highest infection Rate compared to population

select location, population, max(total_cases) as highestInfectionCount, Max((total_cases/population))*100 as PercentagePopulationInfected
from CovidDeaths
--Where location like '%states%'
Group by location, population
Order by PercentagePopulationInfected desc

--Showing countries with Highest death count per population

select location, max(cast(total_deaths AS int)) as TotalDeathCount
from CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by location
Order by TotalDeathCount  desc

--Let's break things down by continent
--Showing continents with the highest death count per population

select Continent, max(cast(total_deaths AS int)) as TotalDeathCount
from CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by Continent
Order by TotalDeathCount  desc

select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))
/sum(new_cases)*100 as DeathPercentage
from CovidDeaths
where continent is not null 
order by 1,2

--Looking at Total population vs vaccinations
--use CTE

with popvsVac(continent, Location, Date, Population, new_vaccination,RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date)as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
select * from popvsVac

--use temporary table

drop table if exists #percentPopulationVaccinated 
create table #percentPopulationVaccinated  

( Continent nvarchar(255),
location nvarchar(255),
population numeric ,
new_vaccinations numeric,
RollingPeopleVaccinated numeric)


insert into #percentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date)as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

select*,(RollingPeopleVaccinated/population)*100
from #percentPopulationVaccinated






