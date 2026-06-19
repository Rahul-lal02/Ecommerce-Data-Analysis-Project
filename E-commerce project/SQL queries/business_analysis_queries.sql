SELECT 
    SUM(Sales) AS total_sales
FROM dbo.superstore_sales;

SELECT 
    SUM(Profit) AS total_profit
FROM dbo.superstore_sales;

SELECT SUM(Sales) as toltal_sales from dbo.superstore_sales;

SELECT 
    Category,
    SUM(Sales) AS total_sales
FROM dbo.superstore_sales
GROUP BY Category;

SELECT 
    Category,
    SUM(Sales) AS total_sales
FROM dbo.superstore_sales
GROUP BY Category
ORDER BY total_sales DESC;


SELECT category,
    SUM(Profit) AS total_profit
FROM dbo.superstore_sales
GROUP BY Category 
ORDER BY total_profit DESC;

--“Which specific product types are causing losses?”-- furniture == lowest profit

SELECT 
    Sub_Category,
    SUM(Profit) AS total_profit
FROM dbo.superstore_sales
GROUP BY Sub_Category
ORDER BY total_profit ASC;

--tables, bookcases and supplies causing -ve profit--

SELECT 
    Discount,
    AVG(Profit) AS avg_profit
FROM dbo.superstore_sales
GROUP BY Discount
ORDER BY Discount DESC;

--"Discount impact analysis revealed that profit margins decline sharply beyond 
--20% discount levels, with discounts above 30% consistently generating losses."



SELECT 
    Region,
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit
FROM dbo.superstore_sales
GROUP BY Region
ORDER BY total_sales DESC;

SELECT 
    Region,
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit
FROM dbo.superstore_sales
GROUP BY Region
ORDER BY total_profit DESC;

--"Although the Central region generated higher revenue than the South region,
-- its profitability remained lower, indicating possible pricing or operational inefficiencies."


SELECT TOP 10
    State,
    SUM(Profit) AS total_loss
FROM dbo.superstore_sales
GROUP BY State
ORDER BY total_loss ASC;

--"Drill-down profitability analysis identified Texas, Ohio, and Pennsylvania as major loss-generating states,
-- contributing significantly to weak regional profitability in the Central region."

SELECT TOP 10
    State,
    SUM(Profit) AS total_profit
FROM dbo.superstore_sales
GROUP BY State
ORDER BY total_profit DESC;


SELECT 
    Segment,
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit,
    SUM(Quantity) AS total_quantity
FROM dbo.superstore_sales
GROUP BY Segment
ORDER BY total_profit DESC;

SELECT top 1 * from dbo.superstore_sales;
SELECT

SELECT
Sales,
Profit,
CASE
    WHEN Profit > 0 THEN 'Profit'
    WHEN Profit < 0 THEN 'Loss'
    ELSE 'Break-even'
END AS profit_status
FROM dbo.superstore_sales;

SELECT
    Profit,
    CASE
        WHEN Profit > 0 THEN 'Profit'
        WHEN Profit < 0 THEN 'Loss'
        ELSE 'Break-even'
    END AS profit_status
FROM dbo.superstore_sales;


--------------------------------------------------------

SELECT
    CASE
        WHEN Profit > 0 THEN 'Profit'
        WHEN Profit < 0 THEN 'Loss'
        ELSE 'Break-even'
    END AS profit_status,
    COUNT(*) AS total_orders
FROM dbo.superstore_sales
GROUP BY
    CASE
        WHEN Profit > 0 THEN 'Profit'
        WHEN Profit < 0 THEN 'Loss'
        ELSE 'Break-even'
    END;


    SELECT
    CASE
        WHEN Profit > 0 THEN 'Profit'
        WHEN Profit < 0 THEN 'Loss'
        ELSE 'Break-even'
    END AS profit_status,
    SUM(Sales) AS total_sales
FROM dbo.superstore_sales
GROUP BY
    CASE
        WHEN Profit > 0 THEN 'Profit'
        WHEN Profit < 0 THEN 'Loss'
        ELSE 'Break-even'
    END;

    

SELECT
    Sales,
    Profit,
    CASE
        WHEN Profit > 0 THEN 'Profit'
        WHEN Profit < 0 THEN 'Loss'
        ELSE 'Break-even'
    END AS profit_status
FROM dbo.superstore_sales;


---core business KPI--
--total sales--
SELECT
    ROUND(SUM(Sales),2) AS Total_Sales
FROM dbo.superstore_sales;


--total profit--
SELECT
    ROUND(SUM(Profit),2) AS Total_Profit
FROM dbo.superstore_sales;


--total quantity sold--
SELECT
    SUM(Quantity) AS Total_Quantity_Sold
FROM dbo.superstore_sales;

--Avergae sales per records--
SELECT
    ROUND(AVG(Sales),2) AS Average_Sales
FROM dbo.superstore_sales;


--profit margin %--
SELECT
    ROUND(
        (SUM(Profit) * 100.0) / SUM(Sales),
        2
    ) AS Profit_Margin_Percentage
FROM dbo.superstore_sales;


----------------Rank Categories by Profit------------------
SELECT
    Category,
    SUM(Profit) AS Total_Profit,
    RANK() OVER (
        ORDER BY SUM(Profit) DESC
    ) AS Profit_Rank
FROM dbo.superstore_sales
GROUP BY Category;

----------------Rank States by Sales----------------------
SELECT
    State,
    SUM(Sales) AS Total_Sales,
    RANK() OVER (
        ORDER BY SUM(Sales) DESC
    ) AS Sales_Rank
FROM dbo.superstore_sales
GROUP BY State;

------------------------Top State Within Each Region--------------------------
WITH StateSales AS
(
    SELECT
        Region,
        State,
        SUM(Sales) AS Total_Sales,
        RANK() OVER
        (
            PARTITION BY Region
            ORDER BY SUM(Sales) DESC
        ) AS Sales_Rank
    FROM dbo.superstore_sales
    GROUP BY Region, State
)

SELECT *
FROM StateSales
WHERE Sales_Rank = 1;

--------Category Contribution to Total Revenue-----------
SELECT
    Category,
    SUM(Sales) AS Category_Sales,

    ROUND(
        SUM(Sales) * 100.0 /
        SUM(SUM(Sales)) OVER (),
        2
    ) AS Sales_Percentage
FROM dbo.superstore_sales
GROUP BY Category;

----------------Running Profit Analysis------------------------
SELECT
    State,
    SUM(Profit) AS Total_Profit,

    SUM(SUM(Profit))
    OVER (
        ORDER BY SUM(Profit) DESC
    ) AS Running_Profit
FROM dbo.superstore_sales
GROUP BY State;
----------------------Rank Categories by Profit-----------------------------------------
SELECT
    Category,
    SUM(Profit) AS Total_Profit,
    RANK() OVER (
        ORDER BY SUM(Profit) DESC
    ) AS Profit_Rank
FROM dbo.superstore_sales
GROUP BY Category;

---------------DENSE_RANK() vs RANK()-------------------

SELECT
    Category,
    SUM(Profit) AS Total_Profit,
    DENSE_RANK() OVER (
        ORDER BY SUM(Profit) DESC
    ) AS Profit_Rank
FROM dbo.superstore_sales
GROUP BY Category;

-------------PARTITION BY + RANK()------------------------------------------
SELECT
    Region,
    State,
    SUM(Sales) AS Total_Sales,

    RANK() OVER (
        PARTITION BY Region
        ORDER BY SUM(Sales) DESC
    ) AS Sales_Rank

FROM dbo.superstore_sales
GROUP BY Region, State;

--portfolio insights
--Using the RANK() window function with PARTITION BY, state-level sales 
--performance was analyzed within each region. Texas, New York, Florida, and California emerged
--as the highest-revenue states in the Central, East, South, and West regions respectively.
-----------------------------------------------------------------------------------------------------------
--CTE + Window Function--
--Just show me the best-performing state from each region--
WITH StateSales AS
(
    SELECT
        Region,
        State,
        SUM(Sales) AS Total_Sales,

        RANK() OVER
        (
            PARTITION BY Region
            ORDER BY SUM(Sales) DESC
        ) AS Sales_Rank

    FROM dbo.superstore_sales
    GROUP BY Region, State
)

SELECT
    Region,
    State,
    Total_Sales
FROM StateSales
WHERE Sales_Rank = 1;
--Using a CTE combined with RANK() and PARTITION BY, the highest-performing state within each region was identified. 
--California emerged as the strongest revenue-generating state overall, while Texas, New York, and Florida led their respective regions.--
--this is the business insights for above query

--Which category contributes the most to overall company revenue?--
--Instead of just showing sales numbers, we'll calculate each category's percentage contribution.
SELECT
    Category,
    SUM(Sales) AS Category_Sales,

    ROUND(
        SUM(Sales) * 100.0 /
        SUM(SUM(Sales)) OVER (),
        2
    ) AS Sales_Percentage
FROM dbo.superstore_sales
GROUP BY Category
ORDER BY Category_Sales DESC;

--business insights--
--Technology is the largest revenue contributor, accounting for 36.4% of total company sales. 
--Furniture and Office Supplies contribute 32.3% and 31.3% respectively, 
--indicating a relatively balanced revenue distribution across categories, with Technology maintaining a clear lead.



--ROW_NUMBER()--
SELECT
    Region,
    State,
    SUM(Sales) AS Total_Sales,

    ROW_NUMBER() OVER
    (
        PARTITION BY Region
        ORDER BY SUM(Sales) DESC
    ) AS Row_Num

FROM dbo.superstore_sales
GROUP BY Region, State;



--Continue Power BI phase of Ecommerce Project--
--Continue Power BI phase of Ecommerce Project--



--Resume content--
--E-Commerce Sales & Profitability Analysis
--Analyzed sales, profit, discount, regional, and product performance using SQL Server and Power BI.
--Built interactive dashboards using DAX measures, KPI cards, slicers, and business-driven visualizations.
--Applied advanced SQL concepts including Window Functions (RANK, DENSE_RANK, ROW_NUMBER) and 
--CTEs to identify top-performing regions, products, and profitability drivers.--


USE EcommerceDB;

select * from INFORMATION_SCHEMA.TABLES;

select name from sys.databases;


SELECT * FROM dbo.superstore_sales;

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'superstore_sales';

