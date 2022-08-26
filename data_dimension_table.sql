-- DATA DIMENSION SCRIPT

DROP TABLE IF EXISTS date_dimension;
TRUNCATE TABLE date_dimension;
DROP PROCEDURE IF EXISTS sp_date_dimension;

-- CREATE DATE DIMENSION TABLE
CREATE TABLE date_dimension (
			 day_key INT NOT NULL AUTO_INCREMENT,   -- primay key.
			 date DATETIME,     -- yyyy-mm-dd 00:00:00 format
			 day_number INT(2),    -- day number within month
			 day_of_year INT(4), -- day number within year
			 day_of_week INT(2), -- integer day of week
			 day_of_week_name VARCHAR(10), -- name of the day of the week
			 week_num INT(2), -- week of the year 
			 week_begin_date DATE,  -- week begin date
			 week_end_date DATE, -- week end date
			 month_num INT(2) ,  -- month in number, ie. 12
			 month_name VARCHAR(15),  -- month in name, ie. December
			 YEARMONTH_NUM INT(6),  -- year and month in number, ie. 201212
			 Quarter INT(2),  -- quarter in number, ie 4
			 Year INT(4), -- year in number, ie, 2012
			 created_date TIMESTAMP NOT NULL,
			 PRIMARY KEY (day_key)
 );
 
-- Stored Procedure to create a daily date dimension table with start and end dates as 
-- inputs.  
DELIMITER //

CREATE PROCEDURE sp_date_dimension (in p_start_date DATETIME, p_end_date DATETIME)
BEGIN
	-- VARIABLES
	DECLARE StartDate DATETIME;
	DECLARE EndDate DATETIME;
	DECLARE LoopDate DATETIME;

	-- SET VARIABLES TO INPUT PARAMETERS
	SET StartDate = p_start_date; -- Start Date from input parameter
	SET EndDate = p_end_date; -- End Date from input parameter
	SET LoopDate = StartDate; -- Start loop from Start Date and iterate

		-- Loop through each day from start to end date and insert into date_dimension table
		WHILE LoopDate <= EndDate DO

			INSERT INTO date_dimension(
						date,
						day_number ,
						Day_of_Year,
						Day_of_Week,
						Day_of_week_name,
						Week_num,
						week_begin_date,
						week_end_date,
						Month_num,
						Month_Name,
						yearmonth_num,
						Quarter,
						Year,
						created_date
			)
			SELECT		LoopDate date,
						DAY(LoopDate) AS day_number,
						DAYOFYEAR(LoopDate) AS day_of_year,
						WEEKDAY(LoopDate) AS day_of_week,
						DAYNAME(LoopDate) AS day_of_week_name,
						WEEK(LoopDate) AS week_num,
						DATE_ADD(LoopDate, INTERVAL  - WEEKDAY(LoopDate) DAY) AS week_begin_date,
						DATE_ADD(DATE_ADD(LoopDate, INTERVAL - WEEKDAY(LoopDate) DAY), INTERVAL 6 DAY) AS week_end_date,
						MONTH(LoopDate) AS month_num,
						MONTHNAME(LoopDate) AS month_name,
						CONCAT(year(LoopDate), LPAD(MONTH(LoopDate),2, '0')) AS YEARMONTH_NUM,
						QUARTER(LoopDate) AS Quarter,
						YEAR(LoopDate) AS Year,
						NOW() AS created_date;

			-- Iterate the @LoopDate variable by 1 day
			Set LoopDate = ADDDATE(LoopDate,1);

		END WHILE;
	COMMIT;
END;
//