create database Pharmaceutical_inventory_analysis;
use Pharmaceutical_inventory_analysis;


CREATE TABLE materials (
    Material VARCHAR(50),
    Material_Description VARCHAR(255),
    Plant VARCHAR(50),
    Storage_Location VARCHAR(50),
    Movement_Type INT,
    Posting_Date DATE,
    Qty_in_Un_of_Entry INT,
    Unit_of_Entry VARCHAR(50),
    Movement_Type_Text VARCHAR(255),
    Document_Date DATE,
    Qty_in_OPUn INT,
    Order_Price_Unit VARCHAR(50),
    Order_Unit VARCHAR(50),
    Qty_in_order_unit INT,
    Entry_Date DATE,
    Amount_in_LC DECIMAL(15, 2),
    Purchase_Order VARCHAR(50),
    Movement_indicator VARCHAR(50),
    Base_Unit_of_Measure VARCHAR(50),
    Quantity INT,
    Material_Doc_Year INT,
    Debit_Credit_ind VARCHAR(1),
    Trans_Event_Type VARCHAR(50),
    Material_Type VARCHAR(50),
    Vendor_Code VARCHAR(50)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Cleaned_Data_Set.csv'
INTO TABLE materials
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select * from materials;

SELECT COUNT(*) FROM materials;
SELECT
    AVG(Qty_in_Un_of_Entry) AS avg_qty,
    MIN(Qty_in_Un_of_Entry) AS min_qty,
    MAX(Qty_in_Un_of_Entry) AS max_qty,
    SUM(Qty_in_Un_of_Entry) AS total_qty
FROM materials;

SELECT Material, COUNT(*) AS freq
FROM materials
GROUP BY Material
ORDER BY freq DESC
LIMIT 10;

SELECT Movement_Type, COUNT(*) AS count
FROM materials
GROUP BY Movement_Type
ORDER BY count DESC;

-- Replace NULL values in a specific column with a default value
UPDATE materials
SET Vendor_Code = 'UNKNOWN'
WHERE Vendor_Code IS NULL;

-- Convert a VARCHAR date to a DATE type if stored as string
ALTER TABLE materials
MODIFY Posting_Date DATE;

DELETE FROM materials
WHERE Qty_in_Un_of_Entry < 0;

SELECT 
    AVG(Qty_in_Un_of_Entry) AS mean_qty_in_un_of_entry,
    AVG(Qty_in_OPUn) AS mean_qty_in_OPUn,
    AVG(Qty_in_order_unit) AS mean_qty_in_order_unit,
    AVG(Amount_in_LC) AS mean_amount_in_LC,
    AVG(Quantity) AS mean_quantity
FROM materials;


-- Median for Qty_in_Un_of_Entry
SELECT AVG(subquery.Qty_in_Un_of_Entry) AS median_qty_in_un_of_entry
FROM (
    SELECT Qty_in_Un_of_Entry
    FROM materials
    ORDER BY Qty_in_Un_of_Entry
    LIMIT 2 - (SELECT COUNT(*) FROM materials) % 2    -- for odd/even record counts
    OFFSET (SELECT (COUNT(*) - 1) / 2 FROM materials)
) AS subquery;

-- Median for Qty_in_OPUn
SELECT AVG(subquery.Qty_in_OPUn) AS median_qty_in_OPUn
FROM (
    SELECT Qty_in_OPUn
    FROM materials
    ORDER BY Qty_in_OPUn
    LIMIT 2 - (SELECT COUNT(*) FROM materials) % 2
    OFFSET (SELECT (COUNT(*) - 1) / 2 FROM materials)
) AS subquery;

-- Median for Qty_in_order_unit
SELECT AVG(subquery.Qty_in_order_unit) AS median_qty_in_order_unit
FROM (
    SELECT Qty_in_order_unit
    FROM materials
    ORDER BY Qty_in_order_unit
    LIMIT 2 - (SELECT COUNT(*) FROM materials) % 2
    OFFSET (SELECT (COUNT(*) - 1) / 2 FROM materials)
) AS subquery;

-- Median for Amount_in_LC
SELECT AVG(subquery.Amount_in_LC) AS median_amount_in_LC
FROM (
    SELECT Amount_in_LC
    FROM materials
    ORDER BY Amount_in_LC
    LIMIT 2 - (SELECT COUNT(*) FROM materials) % 2
    OFFSET (SELECT (COUNT(*) - 1) / 2 FROM materials)
) AS subquery;

-- Median for Quantity
SELECT AVG(subquery.Quantity) AS median_quantity
FROM (
    SELECT Quantity
    FROM materials
    ORDER BY Quantity
    LIMIT 2 - (SELECT COUNT(*) FROM materials) % 2
    OFFSET (SELECT (COUNT(*) - 1) / 2 FROM materials)
) AS subquery;



-- Mode for Qty_in_Un_of_Entry
SELECT Qty_in_Un_of_Entry AS mode_qty_in_un_of_entry, COUNT(*) AS frequency
FROM materials
GROUP BY Qty_in_Un_of_Entry
ORDER BY frequency DESC
LIMIT 1;

-- Mode for Qty_in_OPUn
SELECT Qty_in_OPUn AS mode_qty_in_OPUn, COUNT(*) AS frequency
FROM materials
GROUP BY Qty_in_OPUn
ORDER BY frequency DESC
LIMIT 1;

-- Mode for Qty_in_order_unit
SELECT Qty_in_order_unit AS mode_qty_in_order_unit, COUNT(*) AS frequency
FROM materials
GROUP BY Qty_in_order_unit
ORDER BY frequency DESC
LIMIT 1;

-- Mode for Amount_in_LC
SELECT Amount_in_LC AS mode_amount_in_LC, COUNT(*) AS frequency
FROM materials
GROUP BY Amount_in_LC
ORDER BY frequency DESC
LIMIT 1;

-- Mode for Quantity
SELECT Quantity AS mode_quantity, COUNT(*) AS frequency
FROM materials
GROUP BY Quantity
ORDER BY frequency DESC
LIMIT 1;


SELECT
    VAR_POP(Qty_in_Un_of_Entry) AS variance_qty,
    STDDEV_POP(Qty_in_Un_of_Entry) AS stddev_qty
FROM materials;

SELECT
    AVG(Qty_in_Un_of_Entry) AS mean_qty,
    (SELECT AVG(subquery.Qty_in_Un_of_Entry) 
     FROM (SELECT Qty_in_Un_of_Entry 
           FROM materials 
           ORDER BY Qty_in_Un_of_Entry 
           LIMIT 2 - (SELECT COUNT(*) FROM materials) % 2 
           OFFSET (SELECT (COUNT(*) - 1) / 2 FROM materials)) AS subquery) AS median_qty,
    (SELECT Qty_in_Un_of_Entry 
     FROM materials 
     GROUP BY Qty_in_Un_of_Entry 
     ORDER BY COUNT(*) DESC 
     LIMIT 1) AS mode_qty,
    MIN(Qty_in_Un_of_Entry) AS min_qty,
    MAX(Qty_in_Un_of_Entry) AS max_qty,
    VAR_POP(Qty_in_Un_of_Entry) AS variance_qty,
    STDDEV_POP(Qty_in_Un_of_Entry) AS stddev_qty,
    COUNT(*) AS total_count
FROM materials;

SELECT
    AVG(Qty_in_Un_of_Entry) AS mean_qty,
    MIN(Qty_in_Un_of_Entry) AS min_qty,
    MAX(Qty_in_Un_of_Entry) AS max_qty,
    VAR_POP(Qty_in_Un_of_Entry) AS variance_qty,
    STDDEV_POP(Qty_in_Un_of_Entry) AS stddev_qty,
    COUNT(*) AS total_count,
    AVG(Amount_in_LC) AS mean_amount,
    MIN(Amount_in_LC) AS min_amount,
    MAX(Amount_in_LC) AS max_amount,
    VAR_POP(Amount_in_LC) AS variance_amount,
    STDDEV_POP(Amount_in_LC) AS stddev_amount
FROM materials;






