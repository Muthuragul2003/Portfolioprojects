---COVID DEATH AND VACCINATION DATA

SELECT *
FROM PortfolioProject.dbo.CovidDeaths

SELECT *
FROM PortfolioProject.dbo.CovidVaccinations


---TOTAL DEATH VS TOTAL CASES

SELECT location,population,date,total_cases,total_deaths,(total_deaths/total_cases)*100 AS Percentageofdeath
FROM PortfolioProject.dbo.CovidDeaths
ORDER BY location,population

---TOTAL DEATH VS TOTAL POPULATTION

SELECT location,population,date,total_cases,(total_cases/population)*100 AS PercentagePopulationInfected
FROM PortfolioProject.dbo.CovidDeaths
WHERE Continent IS NOT NULL
ORDER BY location,population

---COUNTRIES WITH HIGHEST INFECTED RATE COMPARED TO POPULATION

SELECT location,population,MAX(total_cases) AS Highinfectedrate
FROM PortfolioProject.dbo.CovidDeaths
WHERE Continent IS NOT NULL
GROUP BY location,population
ORDER BY Highinfectedrate DESC

---COUNTRIES WITH HIGHEST DEATH RATE

SELECT location,MAX(CAST(total_deaths as int)) AS Highdeathrate
FROM PortfolioProject.dbo.CovidDeaths
WHERE Continent IS NOT NULL
GROUP BY location
ORDER BY Highdeathrate DESC

---BREAKING THROUGH CONTINENT
 ---  THE CONTINENT WITH HIGHEST DEATH COUNT PER POPULATION

SELECT location,MAX(CAST(total_deaths as int)) AS Totaldeath
FROM PortfolioProject.dbo.CovidDeaths
WHERE Continent IS NULL
GROUP  BY location 
ORDER BY Totaldeath DESC

---GLOBAL NUMBERS


---TOTAL POPULATION VS VACCINATION
---SHOWS THE PERCENTAGE OF PEOPLE VACCINATED


SELECT dea.continent ,dea.date, dea.location, dea.population, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location,dea.date) as peoplevaccinated

FROM PortfolioProject.dbo.CovidDeaths dea
JOIN PortfolioProject.dbo.CovidVaccinations vac
      ON dea.location = vac.location
	  AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY population DESC,  peoplevaccinated DESC 

---CREATING CTE TABLE FOR THE PERCENTAGE OF PEOPLE VACCINATED
With populationvsvaccination (continent,date,location,population,peoplevaccinated)
as(
SELECT dea.continent ,dea.date, dea.location, dea.population, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location,dea.date) as peoplevaccinated

FROM PortfolioProject.dbo.CovidDeaths dea
JOIN PortfolioProject.dbo.CovidVaccinations vac
      ON dea.location = vac.location
	  AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
)

select *,(peoplevaccinated/population)*100 AS Percentageofpeoplevaccinated
FROM populationvsvaccination
ORDER BY population DESC,peoplevaccinated DESC

---CREATING VIEW FOR STORING DATA FOR VISUALISATION

CREATE VIEW Percentpopulationvaccinated as
With populationvsvaccination (continent,date,location,population,peoplevaccinated)
as(
SELECT dea.continent ,dea.date, dea.location, dea.population, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location,dea.date) as peoplevaccinated

FROM PortfolioProject.dbo.CovidDeaths dea
JOIN PortfolioProject.dbo.CovidVaccinations vac
      ON dea.location = vac.location
	  AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
)

select *,(peoplevaccinated/population)*100 AS Percentageofpeoplevaccinated
FROM populationvsvaccination













