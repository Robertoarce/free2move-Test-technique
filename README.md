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

#### 1)  Create and insert data in an local PostgreSQL.

1. Pre-Work Data Check (<a href="Step%201%20-%20Pre-Work%20Data%20Check.ipynb">Pandas</a>) 
    - 1) Detect the useful champs for our mission.
    - 2) Evaluate data cleanness.

2. Create data base
    - Make 4 tables from the given curated csv files.
    - _**Start**_ postgrl - SQL script.

3. Insert Values to the data base
    - Insert data from the csv files.

#### 2) Each day we want to compute summary statistics by customers (spending, orders etc.)
#### Create a script to compute for a given day these summary statistics.

    - Assumptions on the date scope:
        - The dates are from first historical point until given date.
        - The dates do not need to be formated/checked/validated and are in the form yyyymmdd

1. Create the views on SQL.

2. Add to the docker file. 


