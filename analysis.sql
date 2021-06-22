--Player records

--Most points scored
select pl.player_name as "Name", sum(pgl.pts) as "Total Points"
from player as pl
left join player_game_log as pgl on (pl.player_id = pgl.player_id)
group by pl.player_id
order by sum(pgl.pts) desc;

--Most triple doubles
select pl.player_name as "Name", sum(pgl.td3) as "Triple Doubles"
from player as pl
left join player_game_log as pgl on (pl.player_id = pgl.player_id)
group by pl.player_id
order by sum(pgl.td3) desc;

--Most double doubles
select pl.player_name as "Name", sum(pgl.dd2) as "Double Doubles"
from player as pl
left join player_game_log as pgl on (pl.player_id = pgl.player_id)
group by pl.player_id
order by sum(pgl.dd2) desc;

--Most rebounds
select pl.player_name as "Name", sum(pgl.reb) as "Rebounds"
from player as pl
left join player_game_log as pgl on (pl.player_id = pgl.player_id)
group by pl.player_id
order by sum(pgl.reb) desc;

--Most assists
select pl.player_name as "Name", sum(pgl.ast) as "Assists"
from player as pl
left join player_game_log as pgl on (pl.player_id = pgl.player_id)
group by pl.player_id
order by sum(pgl.ast) desc;

--Most steals
select pl.player_name as "Name", sum(pgl.stl) as "Steals"
from player as pl
left join player_game_log as pgl on (pl.player_id = pgl.player_id)
group by pl.player_id
order by sum(pgl.stl) desc;

--Most blocks
select pl.player_name as "Name", sum(pgl.blk) as "Blocks"
from player as pl
left join player_game_log as pgl on (pl.player_id = pgl.player_id)
group by pl.player_id
order by sum(pgl.blk) desc;

--Most turnovers
select pl.player_name as "Name", sum(pgl.tov) as "Turnovers"
from player as pl
left join player_game_log as pgl on (pl.player_id = pgl.player_id)
group by pl.player_id
order by sum(pgl.tov) desc;

--Most fouls
select pl.player_name as "Name", sum(pgl.pf) as "Fouls Committed"
from player as pl
left join player_game_log as pgl on (pl.player_id = pgl.player_id)
group by pl.player_id
order by sum(pgl.pf) desc;

--Most games
select pl.player_name, count(pgl.player_id) as "Games Played"
from player as pl
left join player_game_log as pgl on (pl.player_id = pgl.player_id)
where pgl.min > 0
group by pl.player_id
order by count(pgl.player_id) desc;

--Most minutes
select pl.player_name as "Name", sum(pgl.min) as "Minutes Played"
from player as pl
left join player_game_log as pgl on (pl.player_id = pgl.player_id)
group by pl.player_id
order by sum(pgl.min) desc;

--Highest average PPG (minimum 50 games)
select pl.player_name as "Name", count(pgl.player_id) as "Games Played", 
round(cast(avg(pgl.pts) as numeric),2) as "Average PPG"
from player as pl
left join player_game_log as pgl on (pl.player_id = pgl.player_id)
where pgl.min > 0
group by pl.player_id
having count(pgl.player_id) > 50
order by avg(pgl.pts) desc;

--Highest average +/- (minimum 50 games)
select pl.player_name as "Name", count(pgl.player_id) as "Games Played",
round(cast(avg(pgl.plus_minus) as numeric),2) as "Average Plus/Minus"
from player as pl
left join player_game_log as pgl on (pl.player_id = pgl.player_id)
group by pl.player_id
having count(pgl.player_id) > 50
order by avg(pgl.plus_minus) desc;

--Fewest Games Per Triple Double (At least 10 triple doubles)
select pl.player_name as "Name", 
round(cast(count(pgl.player_id)/sum(pgl.td3) as numeric),2) as "Games/Triple Double"
from player as pl
left join player_game_log as pgl on (pl.player_id = pgl.player_id)
where pgl.min > 0
group by pl.player_id
having sum(pgl.td3) > 10
order by count(pgl.player_id)/sum(pgl.td3) asc;

--Best Points per 48 min
select pl.player_name as "Name", 
round(cast(sum(pgl.pts)/sum(pgl.min)*48 as numeric),2) as "Points per 48 Min"
from player as pl
left join player_game_log as pgl on (pl.player_id = pgl.player_id)
group by pl.player_id
having sum(pgl.min) > 10000
order by sum(pgl.pts)/sum(pgl.min)*48 desc;

--Most points in a game
select pl.player_name as "Name", t.nickname as "Team", g.date as "Date", 
pgl.pts as "Points Scored"
from player_game_log as pgl
left join player as pl on (pgl.player_id = pl.player_id)
left join game as g on (pgl.game_id = g.game_id)
left join team as t on (pgl.team_id = t.team_id)
order by pgl.pts desc;

--Best +/- in a game
select pl.player_name as "Name", t.nickname as "Team", g.date as "Date", 
pgl.plus_minus as "Plus/Minus Rating"
from player_game_log as pgl
left join player as pl on (pgl.player_id = pl.player_id)
left join game as g on (pgl.game_id = g.game_id)
left join team as t on (pgl.team_id = t.team_id)
where pgl.min > 20
order by pgl.plus_minus desc;

--Instances of 50-40-90 in a single season
select pl.player_name as "Name",
round(cast(sum(pgl.fgm)/sum(pgl.fga)*100 as numeric),2) as "FG %",
round(cast(sum(pgl.fg3m)/sum(pgl.fg3a)*100 as numeric),2) as "3 PT %",
round(cast(sum(pgl.ftm)/sum(pgl.fta)*100 as numeric),2) as "FT %"
from player_game_log as pgl
left join player as pl on (pgl.player_id = pl.player_id)
group by pl.player_id, pgl.season_id
having sum(pgl.fgm)/sum(pgl.fga)*100 > 50 AND sum(pgl.fg3m)/sum(pgl.fg3a)*100 > 40
AND sum(pgl.ftm)/sum(pgl.fta)*100 > 90 AND sum(pgl.fga) > 0 AND
sum(pgl.fg3a) > 0 AND sum(pgl.fta) > 0 AND sum(pgl.fgm) > 300 AND
sum(pgl.fg3m) > 70 AND sum(pgl.ftm) > 130

--Instances of players almost achieving a 50/40/90 season
select pl.player_name as "Name",
round(cast(sum(pgl.fgm)/sum(pgl.fga)*100 as numeric),2) as "FG %",
round(cast(sum(pgl.fg3m)/sum(pgl.fg3a)*100 as numeric),2) as "3 PT %",
round(cast(sum(pgl.ftm)/sum(pgl.fta)*100 as numeric),2) as "FT %"
from player_game_log as pgl
left join player as pl on (pgl.player_id = pl.player_id)
group by pl.player_id, pgl.season_id
having sum(pgl.fgm)/sum(pgl.fga)*100 > 45 AND sum(pgl.fg3m)/sum(pgl.fg3a)*100 > 36
AND sum(pgl.ftm)/sum(pgl.fta)*100 > 86 AND sum(pgl.fga) > 0 AND
sum(pgl.fg3a) > 0 AND sum(pgl.fta) > 0 AND sum(pgl.fgm) > 300 AND
sum(pgl.fg3m) > 70 AND sum(pgl.ftm) > 130 AND
sum(pgl.fgm)/sum(pgl.fga)*100 < 50 AND sum(pgl.fg3m)/sum(pgl.fg3a)*100 < 40
AND sum(pgl.ftm)/sum(pgl.fta)*100 < 90

--Averaging triple double over a season
select pl.player_name as "Name",
round(cast(sum(pgl.pts)/count(pgl.player_id) as numeric), 2) as "PPG",
round(cast(sum(pgl.reb)/count(pgl.player_id) as numeric),2) as "RPG",
round(cast(sum(pgl.ast)/count(pgl.player_id) as numeric),2) as "APG"
from player as pl
left join player_game_log as pgl on (pl.player_id = pgl.player_id)
where pgl.min > 0
group by pl.player_id, pgl.season_id
having sum(pgl.pts)/count(pgl.player_id) > 10 AND sum(pgl.reb)/count(pgl.player_id) > 10
AND sum(pgl.ast)/count(pgl.player_id) > 10
order by sum(pgl.pts)/count(pgl.player_id) desc;

--Close to averaging a triple double over a season
select pl.player_name as "Name",
round(cast(sum(pgl.pts)/count(pgl.player_id) as numeric), 2) as "PPG",
round(cast(sum(pgl.reb)/count(pgl.player_id) as numeric),2) as "RPG",
round(cast(sum(pgl.ast)/count(pgl.player_id) as numeric),2) as "APG"
from player as pl
left join player_game_log as pgl on (pl.player_id = pgl.player_id)
where pgl.min > 0
group by pl.player_id, pgl.season_id
having sum(pgl.pts)/count(pgl.player_id) > 9 AND sum(pgl.reb)/count(pgl.player_id) > 8
AND sum(pgl.ast)/count(pgl.player_id) > 8 
AND sum(pgl.reb)/count(pgl.player_id) < 10 AND sum(pgl.ast)/count(pgl.player_id) < 10
order by sum(pgl.pts)/count(pgl.player_id) desc;

--