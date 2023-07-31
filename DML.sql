-- CUSTOMERS

-- get all Customer IDs and Names to populate the Customer dropdown
SELECT `customerID`, `name` FROM `Customers`

-- add a new Customer
INSERT INTO `Customers` (`customerID`, `name`, `email`, `phoneNumber`, `birthday`) VALUES (:customerID, :name, :email, :phoneNumber, :birthday)

-- update an existing Customer based on submission of the Update Customer form
UPDATE `Customers` SET `name` = :name, `email` = :email, `phoneNumber` = :phoneNumber, `birthday` = :birthday WHERE `customerID` = :customerID

-- delete a Customer
DELETE FROM `Customers` WHERE `customerID` = :customerID

-- select a Customer's name and email based on their ID
SELECT `name`, `email` FROM `Customers` WHERE `customerID` = :customerID

-- EMPLOYEES

-- get all Employees to populate the Employee dropdown
SELECT `employeeID`, `name` FROM `Employees`

-- add a new Employee
INSERT INTO `Employees` (`employeeID`, `name`,`position`, `email`, `phoneNumber`) VALUES (:employeeID, :name, :position, :email, :phoneNumber)

-- update an existing Employee based on submission of the Update Employee form
UPDATE `Employees` SET `name` = :name, `position` = :position, `email` = :email, `phoneNumber` = :phoneNumber WHERE `employeeID` = :employeeID

-- delete a Employee
DELETE FROM `Employees` WHERE `employeeID` = :employeeID

-- select an Employee's name and email based on their ID
SELECT `name`, `email` FROM `Employees` WHERE `employeeID` = :employeeID

-- ORDERS

-- get all Order IDs and orderTotal to populate the Order dropdown
SELECT `orderID`, `orderTotal` FROM `Orders`

-- add a new Order
INSERT INTO `Orders` (`orderID`, `dateTime`, `orderTotal`, `customerID`, `employeeID`) VALUES (:orderID, :dateTime, :orderTotal, :customerID, :employeeID)

-- update an existing Order based on submission of the Update Order form
UPDATE `Orders` SET `dateTime` = :dateTime, `orderTotal` = :orderTotal, `customerID` = :customerID, `employeeID` = :employeeID WHERE `orderID` = :orderID

-- delete a Order
DELETE FROM `Orders` WHERE `orderID` = :orderID

-- select an Order's dateTime and orderTotal based on their ID
SELECT `dateTime`, `orderTotal` FROM `Orders` WHERE `orderID` = :orderID

-- Order_Details

-- get all Order_Details to populate the Order_Details dropdown
SELECT `quantity`, `productID`, `orderID` FROM `Order_Details`

-- update an existing Order_Details based on submission of the Update Order_Details form
UPDATE `Order_Details` SET `quantity` = :quantity, `productID` = :productID, `orderID` = :orderID WHERE `orderID` = :orderID

-- select an Order_Details's quantity and productID based on their ID
SELECT `quantity`, `productID` FROM `Order_Details` WHERE `orderID` = :orderID

-- PRODUCTS

-- get all Product IDs and Names to populate the Product dropdown
SELECT `productID`, `name` FROM `Products`

-- add a new Product
INSERT INTO `Products` (`productID`, `supplierID`, `name`, `price`, `stockQuantity`, `deliveryDate`, `description`) VALUES (:productID, :supplierID, :name, :price, :stockQuantity, :deliveryDate, :description)

-- update an existing Product based on submission of the Update Product form
UPDATE `Products` SET `name` = :name, `price` = :price, `stockQuantity` = :stockQuantity, `deliveryDate` = :deliveryDate, `description` = :description WHERE `productID` = :productID

-- delete a Product
DELETE FROM `Products` WHERE `productID` = :productID

-- select a Product's name and price based on their ID
SELECT `name`, `price` FROM `Products` WHERE `productID` = :productID

-- SUPPLIERS

-- get all Supplier IDs and Names to populate the Supplier dropdown
SELECT `supplierID`, `name` FROM `Suppliers`

-- add a new Supplier
INSERT INTO `Suppliers` (`supplierID`, `name`, `email`, `phoneNumber`) VALUES (:supplierID, :name, :email, :phoneNumber)

-- update an existing Supplier based on submission of the Update Supplier form
UPDATE `Suppliers` SET `name` = :name, `email` = :email, `phoneNumber` = :phoneNumber WHERE `supplierID` = :supplierID

-- delete a Supplier
DELETE FROM `Suppliers` WHERE `supplierID` = :supplierID

-- select a Supplier's name and email based on their ID
SELECT `name`, `email` FROM `Suppliers` WHERE `supplierID` = :supplierID

-- CALCULATIONS

-- Calculate total order amount for each order
SELECT o.`orderID`, SUM(od.`quantity` * p.`price`) AS `totalOrderAmount`
FROM `Orders` o
JOIN `Order_Details` od ON o.`orderID` = od.`orderID`
JOIN `Products` p ON od.`productID` = p.`productID`
GROUP BY o.`orderID`

-- Calculate total sales amount for all orders
SELECT SUM(orderTotal) as `totalSalesAmount` FROM Orders

-- Calculate the average order total
SELECT AVG(orderTotal) as `averageOrderTotal` FROM Orders

-- Calculate the total sales amount for each customer
SELECT c.`name` AS `customerName`, SUM(o.`orderTotal`) AS `totalSalesAmount`
FROM `Customers` c
JOIN `Orders` o ON c.`customerID` = o.`customerID`
GROUP BY c.`name`

-- Calculate the total sales amount for each employee
SELECT e.`name` AS `employeeName`, SUM(o.`orderTotal`) AS `totalSalesAmount`
FROM `Employees` e
JOIN `Orders` o ON e.`employeeID` = o.`employeeID`
WHERE e.`employeeID` = :employeeID
GROUP BY e.`name`

-- Calculate the total quantity ordered for each product
SELECT p.`name` AS `productName`, SUM(od.`quantity`) AS `totalQuantityOrdered`
FROM `Products` p
JOIN `Order_Details` od ON p.`productID` = od.`productID`
GROUP BY p.`name`

-- Calculate the total quantity ordered for each product by a specific customer
SELECT p.`name` AS `productName`, SUM(od.`quantity`) AS `totalQuantityOrdered`
FROM `Products` p
JOIN `Order_Details` od ON p.`productID` = od.`productID`
JOIN `Orders` o ON od.`orderID` = o.`orderID`
JOIN `Customers` c ON o.`customerID` = c.`customerID`
WHERE c.`customerID` = :customerID
GROUP BY p.`name`

-- OTHER DATA MANIPULATION QUERIES

-- Retrieve all orders placed by a specific customer
SELECT * FROM Orders WHERE customerID = :customerID

-- Retrieve all orders placed by a specific employee
SELECT * FROM Orders WHERE employeeID = :employeeID

-- Retrieve customers who have not placed any orders
SELECT * FROM Customers WHERE customerID NOT IN (SELECT customerID FROM Orders)

-- Retrieve employees who have not placed any orders
SELECT * FROM Employees WHERE employeeID NOT IN (SELECT employeeID FROM Orders)

-- Retrieve all orders placed on a specific date
SELECT * FROM Orders WHERE dateTime = :dateTime

-- Retrieve all orders placed on a specific date by a specific customer
SELECT * FROM Orders WHERE dateTime = :dateTime AND customerID = :customerID

-- Retrieve all orders that greater than a specific value
SELECT * FROM Orders WHERE orderTotal > :orderTotal

-- Retrieve all orders that greater than a specific value by a specific customer
SELECT * FROM Orders WHERE orderTotal > :orderTotal AND customerID = :customerID

-- Retrieve all suppliers by a specific product ID
SELECT * FROM Suppliers WHERE productID = :productID
