#Use an existing docker image to bring postgrl 
FROM postgres:latest


#copy fixed files from local to container
COPY ./data/fixed/. .


COPY ./01_Create_tables.sql .
COPY ./02_Main_query.sql .
COPY ./03_Main_query_limited.sql .
COPY ./04_Repeated_users.sql .
COPY ./05_Main_query_daily.sql .

#COPY ./00_sqlfile.txt . 
  
#CMD ["cat 00_sqlfile.txt > 05_Main_query_daily.sql" ]

  