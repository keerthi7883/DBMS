mysql>
CREATE DATABASE StoreDB;
Query OK, 1 row affected (0.02 sec)
mysql> USE StoreDB;
Database changed
2. CREATE TABLE PRODUCTS: mysql>
CREATE TABLE Products ( ->
ProductID INT PRIMARY KEY,
-> ProductName VARCHAR(50),
-> Price DECIMAL(10, 2),
-> Quantity INT
-> );
Query OK, 0 rows affected (0.06 sec)
3. TRIGGER CREATION: mysql>
DELIMITER $$ mysql> mysql> CREATE
TRIGGER trg_Product_Insert
-> BEFORE INSERT ON Products
-> FOR EACH ROW
-> BEGIN
-> IF NEW.Price > 1000 THEN
-> SIGNAL SQLSTATE '45000'
-> SET MESSAGE_TEXT = 'Price cannot exceed 1000';
-> END IF;
-> END $$
Query OK, 0 rows affected (0.04 sec)
Ex No: 8 TRIGGERS FOR OPERATIONS IN DATABASE TABLE
mysql>
mysql> DELIMITER ;
4. TEST INSERT TRIGGER: mysql>
-- Successful insert
mysql> INSERT INTO Products VALUES (1, 'Product A', 500, 10);
Query OK, 1 row affected (0.04 sec)
mysql> mysql> --
Successful insert
mysql> INSERT INTO Products VALUES (2, 'Product B', 200, 15);
Query OK, 1 row affected (0.01 sec)
mysql> mysql> --
Successful insert
mysql> INSERT INTO Products VALUES (3, 'Product C', 300, 20);
Query OK, 1 row affected (0.00 sec)
mysql> mysql> --
Failing insert
mysql> INSERT INTO Products VALUES (4, 'Product X', 1500, 5);
ERROR 1644 (45000): Price cannot exceed 1000 mysql> -- Error:
Price cannot exceed 1000
5. TRIGGER CREATION: mysql> DELIMITER $$
mysql> mysql> CREATE TRIGGER
trg_Product_Update
-> BEFORE UPDATE ON Products
-> FOR EACH ROW
-> BEGIN
-> DECLARE msg VARCHAR(255);
-> SET msg = CONCAT('Product Price Changed: Old = ', OLD.Price, ', New
= ', NEW.Price);
-> INSERT INTO ProductLogs(EventType, EventDetails, EventTime)
-> VALUES ('UPDATE', msg, NOW());
-> END $$
Query OK, 0 rows affected (0.04 sec)
mysql>
mysql> DELIMITER ;
6. CREATE LOG TABLE:
mysql> CREATE TABLE ProductLogs (
-> LogID INT AUTO_INCREMENT PRIMARY KEY,
-> EventType VARCHAR(20),
-> EventDetails TEXT,
-> EventTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP
-> );
Query OK, 0 rows affected (0.03 sec)
7. TEST UPDATE TRIGGER:
mysql> UPDATE Products SET Price = 600 WHERE ProductID = 3;
Query OK, 1 row affected (0.04 sec)
Rows matched: 1 Changed: 1 Warnings: 0
mysql> mysql> SELECT * FROM
ProductLogs;
+-------+-----------+---------------------------------------------------+---------------------+ |
LogID | EventType | EventDetails | EventTime |
+-------+-----------+---------------------------------------------------+---------------------+
| 1 | UPDATE | Product Price Changed: Old = 300.00, New = 600.00 | 2025-
08-23 23:05:40 |
+-------+-----------+---------------------------------------------------+---------------------+
1 row in set (0.00 sec)
8. TRIGGER CREATION: mysql> DELIMITER $$ mysql> mysql> CREATE
TRIGGER trg_Product_Delete
-> BEFORE DELETE ON Products
-> FOR EACH ROW
-> BEGIN
-> DECLARE msg VARCHAR(255);
-> SET msg = CONCAT('Product with ID ', OLD.ProductID, ' deleted.');
-> INSERT INTO ProductLogs(EventType, EventDetails, EventTime)
-> VALUES ('DELETE', msg, NOW());
-> END $$
Query OK, 0 rows affected (0.04 sec)
mysql>
mysql> DELIMITER ;
9. TEST DELETE TRIGGER:
mysql> DELETE FROM Products WHERE ProductID = 2;
Query OK, 1 row affected (0.04 sec)
mysql> mysql> SELECT * FROM
ProductLogs;
+-------+-----------+---------------------------------------------------+---------------------+
| LogID | EventType | EventDetails | EventTime | +----
---+-----------+---------------------------------------------------+---------------------+
| 1 | UPDATE | Product Price Changed: Old = 300.00, New = 600.00 | 2025-
08-23 23:05:40 |
| 2 | DELETE | Product with ID 2 deleted. | 2025-08-23 23:07:23
|
+-------+-----------+---------------------------------------------------+---------------------+
2 rows in set (0.00 sec)
10. PRODUCTS TABLE:
mysql> SELECT * FROM Products;
+-----------+-------------+--------+----------+
| ProductID | ProductName | Price | Quantity |
+-----------+-------------+--------+----------+
| 1 | Product A | 500.00 | 10 |
| 3 | Product C | 600.00 | 20 |
+-----------+-------------+--------+----------+
2 rows in set (0.00 sec)
11. PRODUCTLOGS TABLE:
mysql> SELECT * FROM ProductLogs;
+-------+-----------+---------------------------------------------------+---------------------+ |
LogID | EventType | EventDetails | EventTime |
+-------+-----------+---------------------------------------------------+---------------------+
| 1 | UPDATE | Product Price Changed: Old = 300.00, New = 600.00 | 2025-
08-23 23:05:40 |
| 2 | DELETE | Product with ID 2 deleted. | 2025-08-23 23:07:23
|
+-------+-----------+---------------------------------------------------+---------------------+
2 rows in set (0.00 sec)
