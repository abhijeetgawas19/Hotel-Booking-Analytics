USE theap44a_hotel;

-- 1. Is hotel revenue increasing year on year? 

-- Year 2018 

SELECT SUM(Revenue_Discount) FROM (SELECT (h18.adults+h18.children+h18.babies) as Family, -- Counting the No of Families Members 
h18.meal, -- Type of Meal
mealc.cost, -- Cost of Meal
((SELECT Family) * mealc.cost) as MealCost, -- Meal Cost Per Person
h18.market_segment, -- Market Segment of Consumer
h18.adr, -- Average Daily Rate
ms.discount , -- Discount as per Market Segment of Consumer
(round(((SELECT Family) * h18.adr) + (SELECT MealCost))) as Revenue, -- Revenue after Adding Meal Cost
(round((SELECT Revenue) - (SELECT Revenue) * ms.discount)) as Revenue_Discount -- Revnue after deducting discount
FROM hotel2018 h18
INNER JOIN meal_cost mealc
ON h18.meal = mealc.meal
INNER JOIN market_segment ms
ON h18.market_segment = ms.market_segment
where h18.is_canceled <> 1 # Not Cancelled Revenue
) AS Final_Result_2018;

-- Year 2019 

SELECT SUM(Revenue_Discount) FROM (SELECT (h19.adults+h19.children+h19.babies) as Family, -- Counting the No of Families Members 
h19.meal, -- Type of Meal
mealc.cost, -- Cost of Meal
((SELECT Family) * mealc.cost) as MealCost, -- Meal Cost Per Person
h19.market_segment, -- Market Segment of Consumer
h19.adr, -- Average Daily Rate
ms.discount , -- Discount as per Market Segment of Consumer
(round(((SELECT Family) * h19.adr) + (SELECT MealCost))) as Revenue, -- Revenue after Adding Meal Cost
(round((SELECT Revenue) - (SELECT Revenue) * ms.discount)) as Revenue_Discount -- Revnue after deducting discount
FROM hotel2019 h19
INNER JOIN meal_cost mealc
ON h19.meal = mealc.meal
INNER JOIN market_segment ms
ON h19.market_segment = ms.market_segment
where h19.is_canceled <> 1 # Not Cancelled Revenue
) AS Final_Result_2019;

-- Year 2020
 
SELECT SUM(Revenue_Discount) FROM (SELECT (h20.adults+h20.children+h20.babies) as Family, -- Counting the No of Families Members 
h20.meal, -- Type of Meal
mealc.cost, -- Cost of Meal
((SELECT Family) * mealc.cost) as MealCost, -- Meal Cost Per Person
h20.market_segment, -- Market Segment of Consumer
h20.daily_room_rate, -- Average Daily Rate
ms.discount , -- Discount as per Market Segment of Consumer
(round(((SELECT Family) * h20.daily_room_rate) + (SELECT MealCost))) as Revenue, -- Revenue after Adding Meal Cost
(round((SELECT Revenue) - (SELECT Revenue) * ms.discount)) as Revenue_Discount -- Revnue after deducting discount
FROM hotel2020 h20
INNER JOIN meal_cost mealc
ON h20.meal = mealc.meal
INNER JOIN market_segment ms
ON h20.market_segment = ms.market_segment
where h20.is_canceled <> 1 # Not Cancelled Revenue
) AS Final_Result_2020;

-- 2. What market segment are major contributors of the revenue per year? In there a change year on year?

-- Year 2018 

SELECT h18.market_segment, COUNT(*)
FROM hotel2018 h18
INNER JOIN market_segment ms
ON h18.market_segment = ms.market_segment
WHERE h18.is_canceled = 1
GROUP BY h18.market_segment
ORDER BY COUNT(*) DESC
LIMIT 5;

-- Year 2019

SELECT h19.market_segment, COUNT(*)
FROM hotel2019 h19
INNER JOIN market_segment ms
ON h19.market_segment = ms.market_segment 
WHERE h19.is_canceled = 1
GROUP BY h19.market_segment
ORDER BY COUNT(*) DESC
LIMIT 5;

-- Year 2020

SELECT h20.market_segment, COUNT(*)
FROM hotel2020 h20
INNER JOIN market_segment ms
ON h20.market_segment = ms.market_segment AND h20.is_canceled = 1
GROUP BY h20.market_segment
ORDER BY COUNT(*) DESC
LIMIT 5;


-- 3. When is the hotel at maximum occupancy? Is the period consistent across the years?


-- Year 2018 

SELECT h18.arrival_date_month, COUNT(h18.adults+h18.children+h18.babies) as "Family Count"
FROM hotel2018 h18
WHERE h18.is_canceled = 1
GROUP BY h18.arrival_date_month;

-- Year 2019

SELECT h19.arrival_date_month, COUNT(h19.adults+h19.children+h19.babies) as "Family Count"
FROM hotel2019 h19
WHERE h19.is_canceled = 1
GROUP BY h19.arrival_date_month;

-- Year 2020

SELECT h20.arrival_date_month, COUNT(h20.adults+h20.children+h20.babies) as "Family Count"
FROM hotel2020 h20
WHERE h20.is_canceled = 1
GROUP BY h20.arrival_date_month;

-- 4. When are people cancelling the most?

-- Year 2018 

SELECT h18.arrival_date_month, COUNT(h18.adults+h18.children+h18.babies) as "Family Count"
FROM hotel2018 h18
WHERE h18.is_canceled = 0
GROUP BY h18.arrival_date_month;

-- Year 2019

SELECT h19.arrival_date_month, COUNT(h19.adults+h19.children+h19.babies) as "Family Count"
FROM hotel2019 h19
WHERE h19.is_canceled = 0
GROUP BY h19.arrival_date_month;

-- Year 2020

SELECT h20.arrival_date_month, COUNT(h20.adults+h20.children+h20.babies) as "Family Count"
FROM hotel2020 h20
WHERE h20.is_canceled = 0
GROUP BY h20.arrival_date_month;

-- 5. Are families with kids more likely to cancel the hotel booking?
-- Family Types Adults > 0, Children and or babies > 1
-- Non Family Types, Adult > 0, Children and babies == 0

-- Family
SELECT h18.arrival_date_month, count(*)
FROM hotel2018 h18
WHERE (h18.adults > 0 and (h18.children > 0 or h18.babies > 0)) and h18.is_canceled = 1
GROUP BY h18.arrival_date_month;

SELECT h19.arrival_date_month, count(*)
FROM hotel2019 h19
WHERE (h19.adults > 0 and (h19.children > 0 or h19.babies > 0)) and h19.is_canceled = 1
GROUP BY h19.arrival_date_month;

SELECT h20.arrival_date_month, count(*)
FROM hotel2020 h20
WHERE (h20.adults > 0 and (h20.children > 0 or h20.babies > 0)) and h20.is_canceled = 1
GROUP BY h20.arrival_date_month;

-- Non Family 
SELECT h18.arrival_date_month, count(*)
FROM hotel2018 h18
WHERE (h18.adults > 0 and (h18.children = 0 or h18.babies = 0)) and h18.is_canceled = 1
GROUP BY h18.arrival_date_month;

SELECT h19.arrival_date_month, count(*)
FROM hotel2019 h19
WHERE (h19.adults > 0 and (h19.children = 0 or h19.babies = 0)) and h19.is_canceled = 1
GROUP BY h19.arrival_date_month;

SELECT h20.arrival_date_month, count(*)
FROM hotel2020 h20
WHERE (h20.adults > 0 and (h20.children = 0 or h20.babies = 0)) and h20.is_canceled = 1
GROUP BY h20.arrival_date_month;