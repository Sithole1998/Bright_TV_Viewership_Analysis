
--- Exploratory Data Analysis (Viewership)

SELECT * 
FROM `tv_analysis`.`tv_project`.`viewership` 
LIMIT 100;

--- Count the number of rows (There are 10000 rows with repetion of users)
SELECT COUNT (*) AS Number_of_rows
FROM `tv_analysis`.`tv_project`.`viewership`;

--- Count the number of Bright_tv users
--- The are 4386 people that have subscribed with Bright_tv
SELECT COUNT (DISTINCT UserID0) AS Number_of_Users
FROM `tv_analysis`.`tv_project`.`viewership`;

--- Count the number of Bright_tv users
--- The are 4080 people that have subscribed with Bright_tv (Userid4 has the lowest number of distinct users)
SELECT COUNT (DISTINCT userid4) AS Number_of_Users
FROM `tv_analysis`.`tv_project`.`viewership`;

--- Convert UCT to SA time 
SELECT 
   RecordDate2 AS UTC_Time,
   DATE_FORMAT(RecordDate2 + INTERVAL 2 HOURS, 'HH:mm:ss') AS SA_Time
FROM `tv_analysis`.`tv_project`.`viewership`;

 --- Extract date (Check start date and end date of data collection)   
 --- The data was collected for a duration of 3 months from (2016-01-01 to 2016-04-01)
SELECT 
    MIN(DATE(RecordDate2 + INTERVAL 2 HOURS)) AS start_date,
    MAX(DATE(RecordDate2 + INTERVAL 2 HOURS)) AS end_date
FROM `tv_analysis`.`tv_project`.`viewership`;

--- Min and Max time
--- Min Time - 00:01:00 and Max Time - 23:59:00 
SELECT 
   MIN(DATE_FORMAT(RecordDate2 + INTERVAL 2 HOURS, 'HH:mm:ss')) AS minimum_time,
   MAX(DATE_FORMAT(RecordDate2 + INTERVAL 2 HOURS, 'HH:mm:ss')) AS maximum_time
FROM tv_analysis.tv_project.viewership
WHERE DATE_FORMAT(RecordDate2 + INTERVAL 2 HOURS, 'HH:mm:ss') <> '00:00:00';

--- SELECT the unique Channels (There are 21 different channels Live on Supersports, M-Net and etc)
SELECT DISTINCT Channel2 AS number_of_channels
FROM `tv_analysis`.`tv_project`.`viewership`;

--- Check for NULL values 
SELECT UserID0,
       Channel2,
       RecordDate2,
      `Duration 2`,
       userid4
FROM `tv_analysis`.`tv_project`.`viewership`
WHERE Channel2 IS NULL
OR RecordDate2 IS NULL
OR UserID0 IS NULL
OR `Duration 2` IS NULL;


--- Duration of engagement
SELECT 
   MIN(`Duration 2`) AS minimum_engagement,
   MAX(`Duration 2`) AS maximum_engagement
FROM `tv_analysis`.`tv_project`.`viewership` AS A
  INNER JOIN `tv_analysis`.`tv_project`.`userprofile` AS B
  ON A.UserID0 = B.UserID
  WHERE `Duration 2` <> '00:00:00';


--- Exploratory Data Analysis (Userprofile)
--- View Userprofile in a coding environment 
SELECT * 
FROM `tv_analysis`.`tv_project`.`userprofile` 
LIMIT 100;

--- COUNT the number of users of BrightTV in userprofile 
---- There are 5375 users who have userprofile 
SELECT COUNT (*) 
FROM `tv_analysis`.`tv_project`.`userprofile`;


--- COUNT unique values users of BrightTV in userprofile 
---- There are 5375 users who have userprofile
SELECT COUNT (DISTINCT UserID) 
FROM `tv_analysis`.`tv_project`.`userprofile`;

--- Extract the different Province (Gauteng, Limpopo, Eastern Cape, Kwazulu Natal, North West, Free State, Mpumalanga, Western Cape, Northern Cape)
SELECT DISTINCT Province
  FROM `tv_analysis`.`tv_project`.`userprofile`;

--- COUNT the number of province WHERE province NOT None
---  There users are distributed across the 9 South African Province 
SELECT DISTINCT Province
FROM tv_analysis.tv_project.userprofile
WHERE NOT Province = 'None';

--- Extract the different gender (None is treated as a NULL)
SELECT DISTINCT Gender
  FROM `tv_analysis`.`tv_project`.`userprofile`;

--- Extract race (None is treated as a NULL)
SELECT DISTINCT Race 
  FROM `tv_analysis`.`tv_project`.`userprofile`;


--- MIN age and MAX age 
--- The age range of the Bright TV users is (9 years to 114 years)
SELECT MIN(Age) AS minimum_age,
       MAX(Age) AS maximum_age
FROM `tv_analysis`.`tv_project`.`userprofile`
  WHERE NOT Age = 0;

--- Check for NULL values 
SELECT Race
FROM `tv_analysis`.`tv_project`.`userprofile`
WHERE Race IS NULL;


--- Check for NULL values 
SELECT UserID,
       Gender,
       Race,
       Age,
       Province
FROM `tv_analysis`.`tv_project`.`userprofile`
WHERE UserID IS NULL
OR Gender IS NULL
OR Race IS NULL
OR Age IS NULL
OR Province IS NULL;

---JOIN and Check for NULL values 
SELECT UserID0,
       Channel2,
       RecordDate2,
       `Duration 2`,
       userid4,
       UserID,
       Gender,
       Race,
       Age,
       Province
FROM `tv_analysis`.`tv_project`.`viewership` AS A
  LEFT JOIN `tv_analysis`.`tv_project`.`userprofile` AS B
  ON UserID0 = UserID
WHERE `Duration 2` IS NULL
OR Race IS NULL
OR Gender IS NULL
OR Age IS NULL
OR Channel2 IS NULL
OR RecordDate2 IS NULL
OR Province IS NULL
OR UserID0 IS NULL;

--- Data Processing 
SELECT UserID0,
    DATE(RecordDate2 + INTERVAL 2 HOURS) AS Engagement_date,
    DATE_FORMAT(RecordDate2 + INTERVAL 2 HOURS, 'HH:mm:ss') AS SA_Time,
    MONTHNAME(RecordDate2 + INTERVAL 2 HOURS) AS Month_Name,
    DAYNAME(RecordDate2 + INTERVAL 2 HOURS) AS Day_Name,
    DAY(RecordDate2 + INTERVAL 2 HOURS) AS Day_of_Month,

--- Weekend vs Weekdays  
  CASE 
      WHEN DAYNAME(RecordDate2 + INTERVAL 2 HOURS) IN ('Sun', 'Sat') THEN 'Weekend'
      ELSE 'Weekday'
  END AS Day_Classification, 

--- time bucket 
CASE 
    WHEN DATE_FORMAT(RecordDate2 + INTERVAL 2 HOURS, 'HH:mm:ss') BETWEEN '04:00:00' AND '07:59:59' THEN '01. Early Morning'
    WHEN DATE_FORMAT(RecordDate2 + INTERVAL 2 HOURS, 'HH:mm:ss') BETWEEN '08:00:00' AND '11:59:59' THEN '02. Morning'
    WHEN DATE_FORMAT(RecordDate2 + INTERVAL 2 HOURS, 'HH:mm:ss') BETWEEN '12:00:00' AND '15:59:59' THEN '03. Afternoon'
    WHEN DATE_FORMAT(RecordDate2 + INTERVAL 2 HOURS, 'HH:mm:ss') BETWEEN '16:00:00' AND '19:59:59' THEN '04. Evening'
    WHEN DATE_FORMAT(RecordDate2 + INTERVAL 2 HOURS, 'HH:mm:ss') BETWEEN '20:00:00' AND '23:59:59' THEN '05. Night'
    ELSE '06. Late Night'
END AS Time_Bucket, 

Channel2,
DATE_FORMAT(`Duration 2`, 'HH:mm:ss') AS Interaction_Time,


--- Engagement levels
CASE 
    WHEN DATE_FORMAT(`Duration 2`, 'HH:mm:ss') < '00:01:00' THEN '01. Very Low'
    WHEN DATE_FORMAT(`Duration 2`, 'HH:mm:ss') < '00:15:00' THEN '02. Low'
    WHEN DATE_FORMAT(`Duration 2`, 'HH:mm:ss') < '00:30:00' THEN '03. Medium'
    WHEN DATE_FORMAT(`Duration 2`, 'HH:mm:ss') < '01:00:00' THEN '04. High'
    WHEN DATE_FORMAT(`Duration 2`, 'HH:mm:ss') < '03:00:00' THEN '05. Very High'
    ELSE '06. Extreme Engagement'
END Engagement_Duration,
Gender,
Race,
Age,

--- Age bucket
CASE
        WHEN Age = 0 THEN 'Not Classified'
        WHEN Age BETWEEN 1 AND 5 THEN 'Kids'
        WHEN Age BETWEEN 6 AND 14 THEN 'Children'
        WHEN age BETWEEN 15 AND 24 THEN 'Teens'
        WHEN age BETWEEN 25 AND 34 THEN 'Young Adults'
        WHEN age BETWEEN 35 AND 49 THEN 'Adults'
        WHEN age BETWEEN 50 AND 64 THEN 'Mature Adults'
     ELSE 'Seniors'
END AS Age_Bucket,
Province
FROM `tv_analysis`.`tv_project`.`viewership` AS A
LEFT JOIN `tv_analysis`.`tv_project`.`userprofile` AS B
  ON A.UserID0 = B.UserID;
       
