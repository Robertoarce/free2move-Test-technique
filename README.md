<h4 align="center">
  <img   src="src/logowhite.png" height="140" >
</h4>

 
# Technical TEST 

 
---
### ANALYZE E-COMMERCE DATA

You were recently hired by an E-commerce company. Your mission is to provide insights on sales.

There are four datasets :
* *Products*: a list of available products.
* *Items*: a list of items.
* *Orders*: a list of customer orders on the website.
* *Customers*: a list of customers.

Centralize your projet and code in a Github repository and provide the url once the test is completed.

**To Dos**
1. Create and insert data in an local PostgreSQL.
2. Each day we want to compute summary statistics by customers (spending, orders etc.)
Create a script to compute for a given day these summary statistics.
3. Run that script over the necessary period to inject historic data. Then, identify the top customers
4. How many customers are repeaters ?
5. Package your script in Docker container so that it can be run each day. We expect a `docker-compose.yml` and a CLI to get stats for a specific day.

 ---

# Solution - Overview

1. Pre-Work Data Check (<a href="Step%201%20-%20Pre-Work%20Data%20Check.ipynb">Pandas</a>) 
    - 1) Detect the useful champs for our mission.
    - 2) Clean some points.
    - 3) Export fixed files to a new CSV in "data" folder.

2. Create dockerfile and compose.yml file to:
    - Copy fixed files to the container.
    - Lauch psql with open ports.
    - Launch the "Create_tables" script.
    - Ask for a Valid_Date (we assume date is valid).
    - Launch "Get_answers" script.

---
- Assumptions on the date scope:
    - The dates are from first historical point until given date.
    - The dates do not need to be formated/checked/validated and are in the form 'yyyy-mm-dd'


# INSTRUCTIONS


#### Build from image and Launch the container: 
    
    docker-compose up --build -d

#### Upload the corrected csv files to the container :
    
    docker-compose exec data psql -U postgres -h 10.5.0.5 -f  01_Create_tables.sql

> the container will be up, and the service will be running in the back

# ANSWERS TO THE QUESTIONS

#### 3)  Run that script over the necessary period to inject historic data. Then, identify the top customers

> the date can be changed manually to a specific date by changing the variable 'given_date' (-v given_date='2019-08-01')
    
    docker-compose exec data psql -U postgres -h 10.5.0.5  -v given_date="'2019-05-01'"  -f  02_Main_query.sql

> The top  customers are based on the total price and are ordered from top to bottom.
> To see a limited list with only the top 10 users use :
    
    docker-compose exec data psql -U postgres -h 10.5.0.5  -v given_date="'2019-05-01'"  -f  03_Main_query_limited.sql


#### 4) How many customers are repeaters ?
    
    docker-compose exec data psql -U postgres -h 10.5.0.5  -v given_date="'2019-05-01'"  -f  04_Repeated_users.sql


>To put a query into daily production use:
    
    docker-compose exec data psql -U postgres -h 10.5.0.5  -v given_date= $(date +"'%Y-%m-%d'") -f  05_Main_query_daily.sql

   *_NB: The commandes here given can vary depending on the OS system (UNIX,POWESHELL..) _*
   *_ For example for the UNIX system getting today date in the right format is = $(date +"'%Y-%m-%d'")_*
   *_ The variable 'given_date' in POWERSHELL is assigned -v given_date='2019-05-01' instead of "'2019-05-01'" _*
