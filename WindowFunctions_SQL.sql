Use AdventureWorks2019;

---50. Which territory is having more customers?
SELECT * FROM Sales.Customer
SELECT c.TerritoryID, COUNT(c.CustomerID) AS TotalCustomers
FROM Sales.Customer c
GROUP BY c.TerritoryID
ORDER BY TotalCustomers DESC;

---51.Which territory is having more stores?

SELECT c.TerritoryID, COUNT(c.CustomerID) AS TotalStores
FROM Sales.Customer c
WHERE c.StoreID IS NOT NULL
GROUP BY c.TerritoryID
ORDER BY TotalStores DESC;

--52. Is there any person having more than one credit card?

Select p.BusinessEntityID, p.FirstName, p.LastName, Count(pc.CreditCardID) As CreditCardCount
From Person.Person p
Join Sales.PersonCreditCard pc on p.BusinessEntityID = pc.BusinessEntityID
Join Sales.CreditCard cc on pc.CreditCardID = cc.CreditCardID
Group by p.BusinessEntityID, p.FirstName, p.LastName
Having Count(pc.CreditCardID) > 1
Order By CreditCardCount Desc;


---53. 
Select sod.productID, p.name AS productName, AVG(sod.unitPrice) AS avgSalePrice  
FROM Sales.SalesOrderDetail sod  
JOIN Production.Product p ON sod.productID = p.productID  
GROUP BY sod.productID, p.name  
ORDER BY avgSalePrice DESC;  

---54.

Select sod.ProductID, p.Name AS ProductName, SUM(sod.LineTotal) AS TotalLineValue  
From Sales.SalesOrderDetail sod  
Join Production.Product p On sod.ProductID = p.ProductID  
Where sod.ProductID = (Select Top 1 ProductID  
    From Sales.SalesOrderDetail  
    Group By ProductID  
    Order By COUNT(*) Desc) Group By sod.ProductID, p.Name;  

--55.

Select e.businessEntityID, p.firstName, p.lastName, e.birthDate,  
DATEDIFF(YEAR, e.birthDate, GETDATE()) AS age  
FROM HumanResources.Employee e  
Join Person.Person p ON e.businessEntityID = p.businessEntityID;

---56. Calculate the year of experience of the employee based on hire date

Select e.BusinessEntityID, p.FirstName, p.LastName, DATEDIFF(YEAR, e.HireDate, GETDATE()) AS YearsOfExperience
From HumanResources.Employee e
Join Person.Person p On e.BusinessEntityID = p.BusinessEntityID;


---57. Find the age of employee at the time of joining
SELECT Person.Person.BusinessEntityID, 
    DATEDIFF(YEAR, BirthDate, HireDate) AS AgeAtJoining
FROM HumanResources.Employee
JOIN Person.Person ON Employee.BusinessEntityID = Person.BusinessEntityID;


---58. Find the average age of male and female
SELECT 
    Gender, 
    AVG(DATEDIFF(YEAR, BirthDate, HireDate)) AS AvgAgeAtJoining
FROM HumanResources.Employee e
JOIN Person.Person p ON e.BusinessEntityID = p.BusinessEntityID
GROUP BY Gender;

---59. Which product is the oldest product as on the date (refer the product sell start date)
SELECT TOP 1 
    Name AS ProductName, 
    SellStartDate 
FROM Production.Product 
ORDER BY SellStartDate ASC;

---60. Display the product name, standard cost, and time duration for the same cost. (Product cost history)
SELECT 
    p.Name AS ProductName, ph.StandardCost, 
DATEDIFF(DAY, ph.StartDate, ph.EndDate) AS CostDuration
FROM Production.Product p
JOIN Production.ProductCostHistory ph ON p.ProductID = ph.ProductID;


---61. Find the purchase id where shipment is done 1 month later of order date
SELECT PurchaseOrderID 
FROM Purchasing.PurchaseOrderHeader 
WHERE DATEDIFF(MONTH, OrderDate, ShipDate) = 1;


---62. Find the sum of total due where shipment is done 1 month later of order date ( purchase order header)
SELECT SUM(TotalDue) AS SumTotalDue
FROM Purchasing.PurchaseOrderHeader 
WHERE DATEDIFF(MONTH, OrderDate, ShipDate) = 1;

---63. Find the average difference in due date and ship date based on online order flag
SELECT 
    OnlineOrderFlag, 
    AVG(DATEDIFF(DAY, ShipDate, DueDate)) AS AvgShipDueDiff
FROM Sales.SalesOrderHeader
GROUP BY OnlineOrderFlag;

---WIndows Function Quieries 
---64. Display business entity id, marital status, gender, vacationhr, average vacation based on marital status
SELECT 
    BusinessEntityID, 
    MaritalStatus, 
    Gender, 
    VacationHours, 
    AVG(VacationHours) OVER (PARTITION BY MaritalStatus) AS AvgVacationByMaritalStatus
FROM HumanResources.Employee;

---65. Display business entity id, marital status, gender, vacationhr, average vacation based on gender
SELECT 
    BusinessEntityID, 
    MaritalStatus, 
    Gender, 
    VacationHours, 
    AVG(VacationHours) OVER (PARTITION BY Gender) AS AvgVacationByGender
FROM HumanResources.Employee;

---66. Display business entity id, marital status, gender, vacationhr, average vacation based on organizational level
SELECT 
    BusinessEntityID, 
    MaritalStatus, 
    Gender, 
    VacationHours, 
    JobTitle, 
    AVG(VacationHours) OVER (PARTITION BY JobTitle) AS AvgVacationByLevel
FROM HumanResources.Employee;

---67. Display entity id, hire date, department name and department wise count of employee and count based on organizational level in each dept
SELECT 
    e.BusinessEntityID, 
    e.HireDate, 
    d.Name AS DepartmentName, 
    COUNT(*) OVER (PARTITION BY d.DepartmentID) AS DeptEmployeeCount,
    COUNT(*) OVER (PARTITION BY e.JobTitle) AS OrgLevelCount
FROM HumanResources.Employee e
JOIN HumanResources.EmployeeDepartmentHistory edh ON e.BusinessEntityID = edh.BusinessEntityID
JOIN HumanResources.Department d ON edh.DepartmentID = d.DepartmentID;

---68. Display department name, average sick leave and sick leave per department
SELECT 
    d.Name AS DepartmentName, 
    AVG(e.SickLeaveHours) AS AvgSickLeavePerDept
FROM HumanResources.Employee e
JOIN HumanResources.EmployeeDepartmentHistory edh ON e.BusinessEntityID = edh.BusinessEntityID
JOIN HumanResources.Department d ON edh.DepartmentID = d.DepartmentID
GROUP BY d.Name;

---69. Display the employee details first name, last name, with total count of various shift done by the person and shifts count per department
SELECT 
    e.BusinessEntityID, 
    p.FirstName, 
    p.LastName, 
    COUNT(s.ShiftID) AS TotalShifts,
    COUNT(s.ShiftID) OVER (PARTITION BY d.Name) AS ShiftsPerDepartment
FROM HumanResources.Employee e
JOIN Person.Person p ON e.BusinessEntityID = p.BusinessEntityID
JOIN HumanResources.EmployeeDepartmentHistory edh ON e.BusinessEntityID = edh.BusinessEntityID
JOIN HumanResources.Department d ON edh.DepartmentID = d.DepartmentID
JOIN HumanResources.Shift s ON edh.ShiftID = s.ShiftID
GROUP BY e.BusinessEntityID, p.FirstName, p.LastName, d.Name, s.ShiftID;

---70. Display country region code, group average sales quota based on territory id
SELECT 
    st.TerritoryID, 
    CountryRegionCode, 
    AVG(SalesQuota) AS AvgSalesQuota
FROM Sales.SalesPerson sp
JOIN Sales.SalesTerritory st ON sp.TerritoryID = st.TerritoryID
GROUP BY st.TerritoryID, CountryRegionCode;

---71. Display special offer description, category and avg(discount pct) per the category
SELECT SpecialOfferID, Description, Category, 
       AVG(DiscountPct) AS AvgDiscountPerCategory
FROM Sales.SpecialOffer
GROUP BY SpecialOfferID, Description, Category;

---72. Display special offer description, category and avg(discount pct) per the month
SELECT SpecialOfferID, Description, Category, 
       MONTH(StartDate) AS OfferMonth, 
       AVG(DiscountPct) AS AvgDiscountPerMonth
FROM Sales.SpecialOffer
GROUP BY SpecialOfferID, Description, Category, MONTH(StartDate);

---73. Display special offer description, category and avg(discount pct) per the year
SELECT SpecialOfferID, Description, Category, 
       YEAR(StartDate) AS OfferYear, 
       AVG(DiscountPct) AS AvgDiscountPerYear
FROM Sales.SpecialOffer
GROUP BY SpecialOfferID, Description, Category, YEAR(StartDate);

---74. Display special offer description, category and avg(discount pct) per the type
SELECT SpecialOfferID, Description, Category, Type, 
       AVG(DiscountPct) AS AvgDiscountPerType
FROM Sales.SpecialOffer
GROUP BY SpecialOfferID, Description, Category, Type;

---75. Using rank and dense rand find territory wise top sales person--

SELECT 
    BusinessEntityID AS SalesPersonID, 
    TerritoryID, 
    SalesYTD, 
    RANK() OVER (PARTITION BY TerritoryID ORDER BY SalesYTD DESC) AS SalesRank,
    DENSE_RANK() OVER (PARTITION BY TerritoryID ORDER BY SalesYTD DESC) AS SalesDenseRank
FROM Sales.SalesPerson;




 
