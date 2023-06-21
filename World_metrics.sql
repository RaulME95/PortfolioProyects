--World metrics per day

--sum cases per day and sum day per day independent of the country

select date, sum(new_cases) as total_cases , sum (cast(new_deaths as int)) as total_death , sum (cast(new_deaths as int))/ sum (new_cases)*100 as deathporcentage
from CovidDeaths$
where continent is not null
group by date
order by 1,2


---use CTE

with popVSvac(continent, location, date, population,new_vaccinations, rolling_vac)
as 
(
select death.continent, death.location, death.date, death.population, vacs.new_vaccinations, 
sum(convert(int,vacs.new_vaccinations)) over (partition by death.location order by death.location, death.date) as rolling_vac  
/*particion by location 'cause need to start count when enter to a new country*/
from CovidDeaths$ as death 
join CovidVaccinations$ as vacs
   on death.location=vacs.location and death.date= vacs.date
where death.continent is not null
--order by 2,3
)

select*, (rolling_vac/population) *100 as R
from popVSvac


--temp Table 
drop table if exists #percetPopVac
create table #percetPopVac
(
continent nvarchar (255),
location nvarchar (255),
date datetime,
population numeric,
new_vaccinations numeric,
rolling_vac numeric
)
insert into #percetPopVac
select death.continent, death.location, death.date, death.population, vacs.new_vaccinations, 
sum(convert(int,vacs.new_vaccinations)) over (partition by death.location order by death.location, death.date) as rolling_vac  
/*particion by location 'cause need to start count when enter to a new country*/
from CovidDeaths$ as death 
join CovidVaccinations$ as vacs
   on death.location=vacs.location and death.date= vacs.date
where death.continent is not null
--order by 2,3

select*
from #percetPopVac

