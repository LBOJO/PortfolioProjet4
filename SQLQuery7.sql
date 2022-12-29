Select *
From coviddeaths

Select*
From coviddeaths
Where continent is not null
order by 1,2



--Select *
--From covidvaccinations
--order by 3,4
---Select Data that we are going to be using

Select location , date, total_cases, new_cases, total_deaths,population
From coviddeaths
Where continent is not null
order by 1,2

---looking at Total Cases vs Total Deaths
--shows likehood of dying if you contract covid in your country

Select location , date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From coviddeaths
where location like '%Belgium%'
order by 1,2

---looking at Total Cases vs Population
---Shows what percentage of population got covid

Select location , date, total_cases,Population, (total_cases/Population)*100 as PercentagePopulationInfected
From [dbo].coviddeaths
where location like '%asia%'
order by 1,2

---looking at Countries with Highest Infections Rate compared to Population

Select location ,Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/Population))*100 as  PercentagePopulationInfected
From coviddeaths
--where location like '%asia%'
Group by Location, Population
order by PercentagePopulationInfected desc

---Showing Countries with Highest Death Count Per Population

Select location , MAX(total_Deaths) as TotalDeathCount
From coviddeaths
where continent is null
Group by Location
order by TotalDeathCount desc

----Let's break things down by continent


Select continent , MAX(cast(total_Deaths as int)) as TotalDeathCount
From coviddeaths
Where continent is not null
--where location like '%asia%'
Group by Continent
order by TotalDeathCount desc

---Showing Continents with the highest death count per population


Select continent , MAX(cast(total_Deaths as int)) as TotalDeathCount
From coviddeaths
Where continent is not null
--where location like '%asia%'
Group by Continent
order by TotalDeathCount desc

--- GLOBAL NUMBERS

Select date, SUM(new_cases), Sum(cast(new_deaths as int))--total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From coviddeaths
--where location like '%Belgium%'
Where Continent is not null
Group by date
order by 1,2

Select date, SUM(new_cases)as total_cases, Sum(cast(new_deaths as int)) as Total_deaths , SUM(cast(new_deaths as int))/ Sum (new_cases)*100 as DeathPercentage
From coviddeaths
--where location like '%Belgium%'
Where Continent is not null
--where DeathPercentage is not null
Group by date
order by 1,2

Select SUM(new_cases)as total_cases, Sum(cast(new_deaths as int)) as Total_deaths , SUM(cast(new_deaths as int))/ Sum (new_cases)*100 as DeathPercentage
From coviddeaths
--where location like '%Belgium%'
Where Continent is not null
--where DeathPercentage is not null
---Group by date
order by 1,2

Select *
From covidvaccinations

---looking at Total Population vs Vaccinations


---USE CTE

With  PopvsVac (continent, location, Date , Population,New_vaccinations , RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location,dea.date , dea.population , vac.new_vaccinations
, SUM(CONVERT(INT, vac.new_vaccinations)) OVER ( Partition by dea.Location order by dea.location,dea.date) as rollingPeopleVaccinated
From coviddeaths dea
Join covidvaccinations vac
 on dea.location = vac.location
 and dea.date= vac.date 
 where dea.continent is not null
-- order by 2,3
 )
 Select * , (rollingPeopleVaccinated/Population)*100
 from PopvsVac

 --TEMP TABLE

 CREATE TABLE = #PercentPopulationVaccinated 
 (
 Continent nvarchar(255),
 Location nvarchar(255),
 Date datetime,
 Population numeric,
 New_vaccinations numeric,
 RollingPeopleVaccinated numeric
 )
 Insert into #PercentPopulationVaccinated
 Select dea.continent, dea.location,dea.date , dea.population , vac.new_vaccinations
, SUM(CONVERT(INT, vac.new_vaccinations)) OVER ( Partition by dea.Location order by dea.location,dea.date) as rollingPeopleVaccinated
From coviddeaths dea
Join covidvaccinations vac
 on dea.location = vac.location
 and dea.date= vac.date 
 where dea.continent is not null
-- order by 2,3
 
 Select * , (rollingPeopleVaccinated/Population)*100
 from  #PercentPopulationVaccinated 

--- Create View to store data for later visualizations

Create view PercentPopulationVaccinated as
Select dea.continent, dea.location,dea.date , dea.population , vac.new_vaccinations
, SUM(CONVERT(INT, vac.new_vaccinations)) OVER ( Partition by dea.Location order by dea.location,dea.date) as rollingPeopleVaccinated
From coviddeaths dea
Join covidvaccinations vac
 on dea.location = vac.location
 and dea.date= vac.date 
 where dea.continent is not null
 --order by 2,3

 Select*
 From PercentPopulationVaccinated