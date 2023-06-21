select* --select just countries
from CovidDeaths$
where continent is not null 
order by 3,4

--select* 
--from CovidVaccinations$
--order by 3,4

--Select data that we are going to be using

select location, date, total_cases, new_cases, total_deaths, population
from CovidDeaths$
order by 1,2

--Looking at total cases VS Total deaths
--Shows likelihood of dying if you have covid 2020-2021
select location, date, total_cases, total_deaths, (total_deaths/total_cases * 100) as deathPercetage 
from CovidDeaths$
where location like '%cuba%'
order by 1,2

 --Looking at total cases vs population
 select location, date, total_cases, population, (total_cases/population * 100) as PopPercetage 
from CovidDeaths$
--where location like '%cuba%' 
order by 1,2


--Looking at countries with highest infection rate comparte to population
 select location, population, max(total_cases) as MaxInfect,  max(total_cases/population)*100 as PopPercetageInfected
from CovidDeaths$
group by location, population
order by PopPercetageInfected desc


--Showing countries with highest death cout per population
 select location, population, max(cast(total_deaths as int))/*convert to in a ncvarhcar*/  as total_deathC,  (max(total_deaths)/population)*100 as PopPercetageDeath
from CovidDeaths$
where continent is not null 
group by location, population
order by  total_deathC desc

--Ordering by continent
select location, population, max(cast(total_deaths as int))/*convert to in a ncvarhcar*/  as total_deathC , (max(total_deaths)/population)*100 as PopPercetageDeath
from CovidDeaths$
where continent is null
group by location, population
order by  PopPercetageDeath desc

--America
select location, population, max(cast(total_deaths as int)) as total_deathC
from CovidDeaths$
where continent like '%america%'
group by location, population
order by total_deathC desc


