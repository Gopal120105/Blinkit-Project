USE blinkitdb;
-- Import Data from Table
SELECT * FROM blinkit_data;
SELECT DISTINCT(Item_Fat_Content) from blinkit_data;
SELECT COUNT(*) FROM blinkit_data;

-- Clean the data to improve the quality of data
UPDATE blinkit_data
SET Item_Fat_Content=
CASE
	WHEN Item_Fat_Content IN ('LF','low fat') THEN 'Low Fat'
	WHEN Item_Fat_Content='reg' THEN 'Regular'
	ELSE Item_Fat_Content
END;

-- KPI's
-- Total Sales 
SELECT CONCAT(CAST(SUM(Total_Sales)/1000000 AS DECIMAL(10,2)), ' MILLIONS') as Total_Sales_in_Millions FROM blinkit_data 
WHERE Item_Fat_Content='Low Fat';


-- Average Sales
SELECT AVG(Total_Sales) AS Avg_Sales FROM blinkit_data

SELECT CAST(AVG(Total_Sales) AS DECIMAL(10,0)) AS Avg_Sales FROM blinkit_data
WHERE Outlet_Establishment_Year=2022;


-- No of Items
SELECT COUNT(*) as No_of_Items FROM blinkit_data;


-- Average Rating
SELECT CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating FROM blinkit_data;



-- Total Sales and other KPI's by Fat Content
SELECT Item_Fat_Content, 
		CONCAT(CAST(SUM(Total_Sales)/1000 AS DECIMAL(10,2)),' K') as Total_Sales_In_Thousands,
		CAST(AVG(Total_Sales) AS DECIMAL(10,1)) AS Avg_Sales,
		COUNT(*) as No_of_Items,
		CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating
FROM blinkit_data 
GROUP BY Item_Fat_Content
ORDER BY Total_Sales_In_Thousands DESC;


-- Total Sales and other KPI's by Item Type
SELECT TOP 5 Item_Type, 
		CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
		CAST(AVG(Total_Sales) AS DECIMAL(10,1)) AS Avg_Sales,
		COUNT(*) AS No_of_Items,
		CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating
FROM blinkit_data 
GROUP BY Item_Type
ORDER BY Total_Sales DESC;


-- Sales & KPIs by Outlet Location & Fat Content
SELECT Outlet_Location_Type, Item_Fat_Content,
		CONCAT(cast(SUM(Total_Sales)/1000 as decimal(10,2)),' K') as Total_Sales_In_Thousands,
		CAST(AVG(Total_Sales) AS DECIMAL(10,1)) AS Avg_Sales,
		COUNT(*) as No_of_Items,
		CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating
FROM blinkit_data 
GROUP BY Outlet_Location_Type, Item_Fat_Content
ORDER BY Total_Sales_In_Thousands desc


-- Fat Content by Outlet for Total Sales 
SELECT Outlet_Location_Type, 
       ISNULL([Low Fat], 0) AS Low_Fat, 
       ISNULL([Regular], 0) AS Regular
FROM 
(
    SELECT Outlet_Location_Type, Item_Fat_Content, 
           CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales
    FROM blinkit_data
    GROUP BY Outlet_Location_Type, Item_Fat_Content
) AS SourceTable
PIVOT 
(
    SUM(Total_Sales) 
    FOR Item_Fat_Content IN ([Low Fat], [Regular])
) AS PivotTable
ORDER BY Outlet_Location_Type;



-- Total Sales by Outlet Establishment 
SELECT outlet_establishment_year,
CAST(SUM(Total_Sales) as DECIMAL(10,2)) as Total_Sales,
CAST(AVG(Total_Sales) AS DECIMAL(10,1)) AS Avg_Sales,
		COUNT(*) as No_of_Items,
		CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating
FROM blinkit_data
GROUP BY Outlet_Establishment_Year
ORDER BY Total_Sales DESC;

-- Percentage of Sales by Outlet Size 
SELECT 
    Outlet_Size, 
    CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
    CAST((SUM(Total_Sales) * 100.0 / SUM(SUM(Total_Sales)) OVER()) AS DECIMAL(10,2)) AS Sales_Percentage
FROM blinkit_data
GROUP BY Outlet_Size
ORDER BY Total_Sales DESC; 

-- Sales by Outlet Location 
SELECT 
    Outlet_Location_Type, 
    cast(sum(Total_Sales) as decimal(10,2)) as Total_Sales,
	CAST((SUM(Total_Sales) * 100.0 / SUM(SUM(Total_Sales)) OVER()) AS DECIMAL(10,2)) AS Sales_Percentage,
	CAST(AVG(Total_Sales) AS DECIMAL(10,1)) AS Avg_Sales,
		COUNT(*) as No_of_Items,
		CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating
FROM blinkit_data
GROUP BY Outlet_Location_Type
ORDER BY Total_Sales DESC; 


-- All Metrics by Outlet Type
SELECT 
    Outlet_Type, 
    cast(sum(Total_Sales) as decimal(10,2)) as Total_Sales,
	CAST((SUM(Total_Sales) * 100.0 / SUM(SUM(Total_Sales)) OVER()) AS DECIMAL(10,2)) AS Sales_Percentage,
	CAST(AVG(Total_Sales) AS DECIMAL(10,1)) AS Avg_Sales,
		COUNT(*) as No_of_Items,
		CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating
FROM blinkit_data
GROUP BY Outlet_Type
ORDER BY Total_Sales DESC;