
#set up data base
create database Game_Data;
use Game_Data;

#set up tables 
create table XBox_Sales (
Ranking int not null primary key,
Game varchar (250) not null,
Release_Year year,
Genre varchar (50),
Publisher varchar (250),
NA_Sales float,
EU_Sales float,
JP_Sales float,
Other_Sales float,
Global_Sales float
);

create table PS4_Sales (
Game varchar (250) not null,
Release_Year year,
Genre varchar (50),
Publisher varchar (250),
NA_Sales float,
EU_Sales float,
JP_Sales float,
Other_Sales float,
Global_Sales float,
ID int not null primary key auto_increment
);

#checking data for duplicates

select count(game), count(distinct game) from xbox_sales;

select count(game), count(distinct game) from ps4_sales;


#locating the duplicates

select game, count(game) from xbox_sales
group by game
order by count(game) desc
;

select game, count(game) from ps4_sales
group by game
order by count(game) desc
;

# Having determined that 'Biomutant' is listed twice, check both listing to determine the one to keep

select * from xbox_sales
where game = "biomutant"
;

select * from ps4_sales
where game = "biomutant"
;

#removing the duplicate entries

delete from xbox_sales where ranking = 609;

delete from ps4_sales where ID = 820;


#checking for empty sales data

select count(game) from xbox_sales
where global_sales = 0
;

# set up for exporting cleaned data 

select * from ps4_sales
where global_sales > 0.1
order by global_sales desc
;

select * from xbox_sales
where global_sales > 0.1
order by global_sales desc
;

# join tables and sales from both PS4 and Xbox for export to Tableau

select ps.game, ps.release_year, ps.genre, ps.publisher,
 round(sum(ps.NA_Sales + xb.NA_Sales), 2) as "Total NA Sales", 
 round(sum(ps.EU_Sales + xb.EU_Sales), 2) as "Total EU Sales", 
 round(sum(ps.JP_Sales + xb.JP_Sales), 2) as "Total JP Sales", 
 round(sum(ps.other_Sales + xb.other_Sales), 2) as "Total Other Sales", 
 round(sum(ps.global_Sales + xb.global_Sales), 2) as Total_World_Sales
 from ps4_sales as ps
join xbox_sales as xb on xb.game
group by ps.game
order by Total_World_Sales desc
;

