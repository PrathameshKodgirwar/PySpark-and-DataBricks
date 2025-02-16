use AdventureWorks2019
--1  find the average currency rate conversion from USD to Algerian Dinar and Australian Doller
Select * from Sales.CurrencyRate

Select FromCurrencyCode, ToCurrencyCode, AVG(EndOfDayRate) AS AvgRate From Sales.CurrencyRate
Where FromCurrencyCode = 'USD'  And ToCurrencyCode In ('DZD', 'AUD') Group By FromCurrencyCode, ToCurrencyCode;

--2 Find the products having offer on it and display product name , safety Stock Level, Listprice, and product model id, type of discount, percentage of discount, offer start date and offer end date
Select * from  Sales.SpecialOfferProduct;
Select * from Sales.SpecialOffer;

Select ProductID, 
(Select Name From Production.Product Where Product.ProductID = Sales.SpecialOfferProduct.ProductID) AS ProductName,
(Select SafetyStockLevel From Production.Product Where Product.ProductID = Sales.SpecialOfferProduct.ProductID) AS SafetyStockLevel,
(Select ListPrice From Production.Product Where Product.ProductID = Sales.SpecialOfferProduct.ProductID) AS ListPrice,
(Select ProductModelID From Production.Product Where Product.ProductID = Sales.SpecialOfferProduct.ProductID) AS ProductModelID,
(Select Type From Sales.SpecialOffer Where SpecialOffer.SpecialOfferID = Sales.SpecialOfferProduct.SpecialOfferID) AS DiscountType,
(Select DiscountPct From Sales.SpecialOffer Where SpecialOffer.SpecialOfferID = Sales.SpecialOfferProduct.SpecialOfferID) AS DiscountPercentage,
(Select StartDate From Sales.SpecialOffer Where SpecialOffer.SpecialOfferID = Sales.SpecialOfferProduct.SpecialOfferID) AS OfferStartDate,
(Select EndDate From Sales.SpecialOffer Where SpecialOffer.SpecialOfferID = Sales.SpecialOfferProduct.SpecialOfferID) AS OfferEndDate 
From Sales.SpecialOfferProduct;

Select
p.Name As product_name, 
p.SafetyStockLevel, 
p.ListPrice, 
p.ProductModelID, 
sp.Type, 
sp.DiscountPct, 
sp.StartDate As offer_start_date, 
sp.EndDate As offer_end_date
From Production.Product p
Join Sales.SpecialOfferProduct sop On p.ProductID = sop.ProductID
Join Sales.SpecialOffer sp On sop.SpecialOfferID = sp.SpecialOfferID;


--3. create view to display Product name and Product review
Select * from Production.Product
Select * from Production.ProductReview

Create View ProductReviews As 
Select 
p.Name As ProductName, 
pr.ReviewerName, 
pr.Rating, 
pr.Comments
From Production.Product p
Join Production.ProductReview pr On p.ProductID = pr.ProductID;

Select * from ProductReviews



--4. find out the vendor for product paint, Adjustable Race and blade--
Select * From Purchasing.Vendor;
Select * From Production.Product;
Select * from Purchasing.ProductVendor;

Select 
p.Name AS ProductName, 
v.Name AS VendorName
FROM Production.Product p
JOIN Purchasing.ProductVendor pv ON p.ProductID = pv.ProductID
JOIN Purchasing.Vendor v ON pv.BusinessEntityID = v.BusinessEntityID
WHERE p.Name IN ('Paint', 'Adjustable Race', 'Blade');


--5.  find product details shipped through ZY - EXPRESS


Select *  from Sales.SalesOrderHeader
Select * From Purchasing.ShipMethod
select* from Production.Product


---6  find the taxAmt for products where order date and ship date are on the same day
select 
(select p.Name from Production.Product p where p.ProductID=pd.ProductID)as ProductName,
ph.TaxAmt as Tax_Amount
from Purchasing.PurchaseOrderDetail pd
join Purchasing.PurchaseOrderHeader ph 
on pd.PurchaseOrderID = ph.PurchaseOrderID
where day(ph.OrderDate)=day(ph.ShipDate)

---7. Average Days Required to Ship the Product Based on Shipment Type
SELECT 
    SM.Name AS ShipmentType,
    AVG(DATEDIFF(DAY, SOH.OrderDate, SOH.ShipDate)) AS AvgShippingDays
FROM Sales.SalesOrderHeader SOH
JOIN Purchasing.ShipMethod SM ON SOH.ShipMethodID = SM.ShipMethodID
GROUP BY SM.Name;

---8. Name of Employees Currently Working in Day Shift
Select E.BusinessEntityID, P.FirstName,P.LastName
From HumanResources.Employee E
Join HumanResources.EmployeeDepartmentHistory EDH ON E.BusinessEntityID = EDH.BusinessEntityID
Join HumanResources.Shift S ON EDH.ShiftID = S.ShiftID
Join Person.Person P ON E.BusinessEntityID = P.BusinessEntityID
Where S.Name = 'Day';

---9. Product Name, Service Provider Time, and Average Standard Cost
SELECT 
P.Name AS ProductName,
AVG(PCH.StandardCost) AS AvgStandardCost
FROM Production.Product P
JOIN Production.ProductCostHistory PCH ON P.ProductID = PCH.ProductID
GROUP BY P.Name;

---10. Products with Average Cost More Than 500
Select P.Name AS ProductName,
AVG(PCH.StandardCost) AS AvgStandardCost
From Production.Product P
Join Production.ProductCostHistory PCH ON P.ProductID = PCH.ProductID
Group BY P.Name
Having AVG(PCH.StandardCost) >500;

---11. Employee Who Worked in Multiple Territories

Select 
E.BusinessEntityID,
P.FirstName,
P.LastName,
COUNT(Distinct ET.TerritoryID) As TerritoryCount
From HumanResources.Employee E Join Sales.SalesTerritoryHistory ET On E.BusinessEntityID = ET.BusinessEntityID
JOIN Person.Person P ON E.BusinessEntityID = P.BusinessEntityID
Group By E.BusinessEntityID, P.FirstName, P.LastName Having COUNT(Distinct ET.TerritoryID) > 1;  

---12. Product Model Name and Description for Culture as Arabic
Select pm.Name AS ProductModelName, pd.Description As ProductDescription  
From Production.ProductModel pm  
JOIN Production.ProductModelProductDescriptionCulture pmpdc  
    ON pm.ProductModelID = pmpdc.ProductModelID  
JOIN Production.ProductDescription pd  
    ON pmpdc.ProductDescriptionID = pd.ProductDescriptionID  
WHERE pmpdc.CultureID = 'ar';



--USING SUB-QUIERIES ONLY--

---13.  display EMP name, territory name, saleslastyear salesquota and bonus 
Select 
(Select FirstName + ' ' + LastName From Person.Person Where BusinessEntityID = s.BusinessEntityID) As EmpName,
(Select Name From Sales.SalesTerritory Where TerritoryID = s.TerritoryID) As TerritoryName,
s.SalesLastYear, s.SalesQuota, s.Bonus
From Sales.SalesPerson s;


 --14. display EMP name, territory name, saleslastyear salesquota and bonus from Germany and United Kingdom 
 SELECT 
(SELECT FirstName + ' ' + LastName FROM Person.Person WHERE BusinessEntityID = s.BusinessEntityID) AS EmpName,
(SELECT Name FROM Sales.SalesTerritory WHERE TerritoryID = s.TerritoryID) AS TerritoryName,
s.SalesLastYear, s.SalesQuota, s.Bonus
FROM Sales.SalesPerson s
WHERE s.TerritoryID IN 
(SELECT TerritoryID FROM Sales.SalesTerritory WHERE CountryRegionCode IN 
(SELECT CountryRegionCode FROM Person.CountryRegion WHERE Name IN ('Germany', 'United Kingdom')));

 --15.Find all employees who worked in all North America territory 

 select  distinct TerritoryId,
(select distinct concat(' ',FirstName,LastName)from Person.Person p where p.BusinessEntityID=sp.BusinessEntityID)Emp_Name,
(select name  from Sales.SalesTerritory st where  st.TerritoryID=sp.TerritoryID) TerritoryName,
(select [Group] from Sales.SalesTerritory st1 where st1.TerritoryID=sp.TerritoryID)Group_NAme
from Sales.SalesTerritoryHistory sp WHERE sp.TerritoryID IN (
    SELECT TerritoryID 
    FROM Sales.SalesTerritory 
    WHERE [Group] IN ('North America'))

 --16.find all products in the cart 

 SELECT ProductID, (SELECT Name FROM Production.Product WHERE ProductID = sc.ProductID) AS ProductName
FROM Sales.ShoppingCartItem sc;


 --17. find all the products with special offer 

 SELECT ProductID, (SELECT Name FROM Production.Product WHERE ProductID = sp.ProductID) AS ProductName
FROM Sales.SpecialOfferProduct sp;


---18. Find all employees name , job title, card details whose credit card expired in the month 11 and year as 2008 

---Select p.FirstName, p.LastName, e.JobTitle, cc.CardNumber, cc.ExpMonth, cc.ExpYear FROM Sales.CreditCard cc
---JOIN Sales.PersonCreditCard pcc ON cc.CreditCardID = pcc.CreditCardID JOIN Person.Person p ON pcc.BusinessEntityID = p.BusinessEntityID
---JOIN HumanResources.Employee e ON p.BusinessEntityID = e.BusinessEntityID
---WHERE cc.ExpMonth = 11 AND cc.ExpYear = 2008;

Select(Select CONCAT_WS(' ',FirstName,LastName) from Person.Person p where p.BusinessEntityID= pc.BusinessEntityId) as EmployeeName,
(Select JobTitle from HumanResources.Employee e where e.BusinessEntityID= pc.BusinessEntityID)as Job_Desc,
(Select concat_ws(':', ExpMonth,ExpYear) from Sales.CreditCard cc where cc.CreditCardID = pc.CreditCardID)as Card_details
from Sales.PersonCreditCard pc where pc.CreditCardID in (Select CreditCardID from Sales.CreditCard cc where cc.ExpMonth=11 and cc.ExpYear=2008)

---19. Find the employee whose payment might be revised (Hint : Employee payment history)
Select * from HumanResources.EmployeePayHistory;
Select * from HumanResources.Employee;

SELECT BusinessEntityID, Rate, RateChangeDate
FROM HumanResources.EmployeePayHistory
WHERE RateChangeDate = (
    SELECT MAX(RateChangeDate) 
    FROM HumanResources.EmployeePayHistory eph
    WHERE eph.BusinessEntityID = EmployeePayHistory.BusinessEntityID
);


---20. Find the personal details with address and address type(hint: Business Entiry, Address , Address, Address type)
SELECT * FROM Person.Person;
SELECT * FROM Person.AddressType;
SELECT * FROM Person.Address;

Select p.BusinessEntityID, p.FirstName, p.LastName, a.AddressLine1, a.AddressLine2, a.City, 
sp.Name AS StateProvince, a.PostalCode, at.Name AS AddressType
FROM Person.Person p JOIN Person.BusinessEntityAddress bea ON p.BusinessEntityID = bea.BusinessEntityID
JOIN Person.Address a ON bea.AddressID = a.AddressID JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
JOIN Person.AddressType at ON bea.AddressTypeID = at.AddressTypeID;

--Select p.firstname, p.lastname, a.AddressLine1, a.AddressLine2, a.city, a.StateProvinceID(SELECT name FROM Person.AddressType at WHERE at AddressTypeID)
---type FROM Person.BusinessEntityAddress be, Person.Person p, Person.Address a, Person.AddressType at 
--WHERE P. BusinessEntityID=be.BusinessEntityID and a.AddressID=be.AddressID and at.AddressTypeID=be.AddressTypeID;

---21. Find the name of employees working in group of North America territory---
select TerritoryID,(select concat(' ',FirstName,LastName)from Person.Person p where p.BusinessEntityID=sp.BusinessEntityID)Emp_Name,
(select name from Sales.SalesTerritory st where  st.TerritoryID=sp.TerritoryID) TerritoryName,
(select [Group] from Sales.SalesTerritory st1 where st1.TerritoryID=sp.TerritoryID)Group_Name,SalesLastYear,SalesQuota
from Sales.SalesPerson sp Where sp.TerritoryID IN (Select TerritoryID From Sales.SalesTerritory where [Group] IN ('North America'))

--22. Find the employee whose payment is revised for more than once--
SELECT BusinessEntityID, count(*)as Paymentrevisons FROM HumanResources.EmployeePayHistory 
GROUP BY BusinessEntityID
HAVING count(*) > 1;

SELECT * FROM HumanResources.EmployeePayHistory
WHERE BusinessEntityID=4;

---23. display the personal details of employee whose payment is revised for more than once ---
Select * from HumanResources.Employee
Select * from HumanResources.EmployeePayHistory

Select BusinessEntityID, JobTitle, HireDate From HumanResources.Employee
Where BusinessEntityID IN (Select BusinessEntityID From HumanResources.EmployeePayHistory
Group By BusinessEntityID Having COUNT(RateChangeDate) > 1);

----25. check if any employee from jobcandidate table is having any payment revisions----
Select * From HumanResources.JobCandidate;

Select Count(JobCandidateID) From HumanResources.JobCandidate 
Where BusinessEntityID IN (Select BusinessEntityID From HumanResources.EmployeePayHistory
Group By BusinessEntityID Having Count(RateChangeDate) > 0);

---26. check the department having more salary revision---
Select * From HumanResources.Department
Select * From HumanResources.EmployeePayHistory
Select * From HumanResources.EmployeeDepartmentHistory

Select d.Name AS DepartmentName, Count(eph.BusinessEntityID) As RevisionCount From HumanResources.EmployeePayHistory eph
Join HumanResources.Employee e On eph.BusinessEntityID = e.BusinessEntityID Join HumanResources.EmployeeDepartmentHistory edh On e.BusinessEntityID = edh.BusinessEntityID
Join HumanResources.Department d ON edh.DepartmentID = d.DepartmentID
Group By d.Name Order By RevisionCount Desc;

---27.check the employee whose payment is not yet revised---
Select * From HumanResources.EmployeePayHistory;

Select BusinessEntityID From HumanResources.EmployeePayHistory
Group By BusinessEntityID
Having Count(RateChangeDate) = 1;

---28. find the job title having more revised payments---
Select * from HumanResources.EmployeePayHistory

Select Top 1 e.JobTitle, 
(Select COUNT(*) FROM HumanResources.EmployeePayHistory eph 
WHERE eph.BusinessEntityID = e.BusinessEntityID) AS RevisionCount
FROM HumanResources.Employee e
ORDER BY RevisionCount DESC;

---29. find the employee whose payment is revised in shortest duration (inline view) 
Select eph.BusinessEntityID, 
(Select FirstName + ' ' + LastName From Person.Person 
Where BusinessEntityID = eph.BusinessEntityID) As EmployeeName,
eph.Rate, eph.RateChangeDate, eph.NextChangeDuration
From (Select eph1.BusinessEntityID, eph1.Rate, eph1.RateChangeDate, DATEDIFF(DAY, eph1.RateChangeDate, 
(Select Min(eph2.RateChangeDate) From HumanResources.EmployeePayHistory eph2 
Where eph2.BusinessEntityID = eph1.BusinessEntityID 
And eph2.RateChangeDate > eph1.RateChangeDate)) 
As NextChangeDuration
From HumanResources.EmployeePayHistory eph1
) eph
Where eph.NextChangeDuration Is Not Null
Order By eph.NextChangeDuration Asc;

---30.find the colour wise count of the product (tbl: product)---
Select * from Production.Product;

Select Color, Count(ProductID) AS ProductCount From Production.Product
Where Color IS NOT NULL Group By Color
Order By ProductCount;

---31.find out the product who are not in position to sell (hint: check the sell start and end date) 

Select ProductID, 
       (Select Name From Production.Product p2 Where p2.ProductID = p1.ProductID) AS ProductName,
       SellStartDate, 
       SellEndDate
From Production.Product p1
Where (SellStartDate > GETDATE() OR SellEndDate < GETDATE());

---32. find the class wise, style wise average standard cost 

Select p.Class,  p.Style, 
(Select Avg(StandardCost) 
From Production.Product p2 
Where p2.Class = p.Class AND p2.Style = p.Style) As AvgStandardCost
From Production.Product p
Group By p.Class, p.Style;

---33. check colour wise standard cost

Select p.Color, 
       (Select AVG(StandardCost) 
        From Production.Product p2 
        Where p2.Color = p.Color) As AvgStandardCost
From Production.Product p
Group By p.Color;

--34. Find the Product Line-wise Standard Cost

Select p.ProductLine, 
(Select Avg(StandardCost) 
From Production.Product p2 
Where p2.ProductLine = p.ProductLine) As AvgStandardCost
From Production.Product p
Group By p.ProductLine;

---35. Find the State-wise Tax Rate

SELECT sp.Name AS StateName, 
       (SELECT TaxRate 
        FROM Sales.SalesTaxRate st 
        WHERE st.StateProvinceID = sp.StateProvinceID) AS TaxRate
FROM Person.StateProvince sp;

---36. Find Department-wise Count of Employees

Select Distinct d.Name As DepartmentName,  
(Select Count(*)  
From HumanResources.EmployeeDepartmentHistory edh  
Where edh.DepartmentID = d.DepartmentID) As EmployeeCount  
From HumanResources.Department d;

---37. Find the Department with the Most Employees

SELECT TOP 1 d.Name AS DepartmentName, COUNT(edh.BusinessEntityID) AS EmployeeCount  
FROM HumanResources.Department d  
JOIN HumanResources.EmployeeDepartmentHistory edh ON d.DepartmentID = edh.DepartmentID  
GROUP BY d.Name  
ORDER BY EmployeeCount DESC;

---38. Check if there is mass hiring of employees on single day

SELECT HireDate,  
(SELECT COUNT(*)  
FROM HumanResources.Employee e2  
WHERE e2.HireDate = e1.HireDate) AS HireCount  
FROM HumanResources.Employee e1  
GROUP BY HireDate  
HAVING COUNT(*) = (SELECT MAX(HireCount)  
FROM (SELECT COUNT(*) AS HireCount FROM HumanResources.Employee  
GROUP BY HireDate) AS HireCounts);

---39. Which product is purccchased more? (purchase order details) 

SELECT top 1 ProductID,  
       (SELECT Name FROM Production.Product p2 WHERE p2.ProductID = pod.ProductID) AS ProductName,  
       (SELECT SUM(OrderQty) FROM Purchasing.PurchaseOrderDetail pod2 WHERE pod2.ProductID = pod.ProductID) AS TotalPurchased  
FROM Purchasing.PurchaseOrderDetail pod  
GROUP BY ProductID  
ORDER BY TotalPurchased DESC;

---40. Find territory-wise customer count

Select Distinct c.TerritoryID,  
       (Select Name From Sales.SalesTerritory st Where st.TerritoryID = c.TerritoryID) As TerritoryName,  
       (Select Count(*) From Sales.Customer c2 Where c2.TerritoryID = c.TerritoryID) As CustomerCount  
From Sales.Customer c  
Where c.TerritoryID IS NOT NULL;

---41. Find the territory with the most customers

Select top 1 TerritoryID, TerritoryName, CustomerCount  
From (  
    Select Distinct c.TerritoryID,  
           (Select Name From Sales.SalesTerritory st Where st.TerritoryID = c.TerritoryID) As TerritoryName,  
           (Select Count(*) From Sales.Customer c2 Where c2.TerritoryID = c.TerritoryID) As CustomerCount  
    From Sales.Customer c  
    Where c.TerritoryID IS NOT NULL  
) As TerritoryCounts  
Order By CustomerCount Desc;

---42. Is there any person having more than one credit card (hint: PersonCreditCard) 

 Select BusinessEntityID, Count(CreditCardID) As CreditCardCount
From Sales.PersonCreditCard
Group By BusinessEntityID
Order By CreditCardCount Asc;

Select BusinessEntityID, Count(CreditCardID) As CreditCardCount
From Sales.PersonCreditCard
Group By BusinessEntityID
Having Count(CreditCardID) > 1;

--43. Find the state wise tax rate (hint: Sales.SalesTaxRate, Person.StateProvince

Select sp.Name As StateName, Avg(st.TaxRate) As AvgTaxRate
From Sales.SalesTaxRate st
Join Person.StateProvince sp 
    On st.StateProvinceID = sp.StateProvinceID
Group By sp.Name;

---44. Find the total values for line total product having maximum order 
Select ProductID, SUM(LineTotal) As TotalLineValue
From Sales.SalesOrderDetail
Where ProductID = (
Select Top 1 ProductID
From Sales.SalesOrderDetail
Group By ProductID
Order By COUNT(*) Desc)
Group By ProductID;

--45. Find the department which is having more employees

Select d.Name As DepartmentName, Count(e.BusinessEntityID) As EmployeeCount
From HumanResources.EmployeeDepartmentHistory e
Join HumanResources.Department d On e.DepartmentID = d.DepartmentID
Group By d.Name
Having Count(e.BusinessEntityID) = (Select Max(EmployeeCount)
From (Select Count(BusinessEntityID) As EmployeeCount
From HumanResources.EmployeeDepartmentHistory
Group By DepartmentID) As DeptCounts);



--46. Calculate the age of employees 

Select FirstName,LastName, BirthDate,  
DateDiff(Year, BirthDate, GetDate()) As Age 
From HumanResources.Employee  
Join Person.Person On Employee.BusinessEntityID = Person.BusinessEntityID;

--47. Calculate the year of experience of the employee based on hire date 
Select BusinessEntityID, HireDate,  
DateDiff(Year, HireDate, GetDate()) As YearsOfExperience  
From HumanResources.Employee;

--48. Find the age of employee at the time of joining 
Select BusinessEntityID, BirthDate, HireDate,  
DateDiff(Year, BirthDate, HireDate) As AgeAtJoining  
From HumanResources.Employee;

--49. Find the average age of male and female 

Select Gender, Avg(DateDiff(Year, BirthDate, GetDate())) As AvgAge  
From HumanResources.Employee  
JOIN Person.Person On Employee.BusinessEntityID = Person.BusinessEntityID  
Group By Gender;

--50. Which product is the oldest product as on the date (refer  the product sell start date)  

Select Top 1 ProductID, Name, SellStartDate  
From Production.Product  
Order By SellStartDate Asc;


---Create Queries---

-- 1. Create Address Type Table
CREATE TABLE Address_Type (
Address_Type_Code CHAR(1) PRIMARY KEY CHECK (Address_Type_Code IN ('B', 'H', 'O')),
Address_Type_Desc VARCHAR(50) NOT NULL);

-- Insert values into Address Type Table
INSERT INTO Address_Type (Address_Type_Code, Address_Type_Desc) 
VALUES ('B', 'Business'), ('H', 'Home'), ('O', 'Office');

-- Create State Info Table
CREATE TABLE State_Info (
State_ID INT PRIMARY KEY IDENTITY(1,1),
State_Name VARCHAR(50) NOT NULL,
Country_Code CHAR(2) NOT NULL);

-- Insert values into State Info Table
INSERT INTO State_Info (State_Name, Country_Code) 
VALUES ('Maharashtra', 'IN'), ('Karnataka', 'IN');

-- Create Customer Table
CREATE TABLE Customer (
Cust_ID INT PRIMARY KEY IDENTITY(1,1),
C_Name VARCHAR(100) NOT NULL CHECK (C_Name NOT LIKE '%[^a-zA-Z ]%'),
Aadhar_Card CHAR(12) UNIQUE NOT NULL,
Mobile_Number CHAR(10) UNIQUE NOT NULL,
Date_of_Birth DATE NOT NULL CHECK (DATEDIFF(YEAR, Date_of_Birth, GETDATE()) > 15),
Address VARCHAR(255) NOT NULL,
Address_Type_Code CHAR(1) NOT NULL CHECK (Address_Type_Code IN ('B', 'H', 'O')),
State_Code CHAR(2) NOT NULL CHECK (State_Code IN ('MH', 'KA')));

-- Insert values into Customer Table
INSERT INTO Customer (C_Name, Aadhar_Card, Mobile_Number, Date_of_Birth, Address, Address_Type_Code, State_Code)
VALUES 
('Rahul Sirsath', '123456789012', '9876543210', '1990-05-15', 'Pune, Maharashtra', 'H', 'MH'),
('Amit Patil', '987654321098', '8765432109', '1995-07-10', 'Bangalore, Karnataka', 'O', 'KA');

-- Alter State_Info Table to change Country_Code data type
ALTER TABLE State_Info ALTER COLUMN Country_Code VARCHAR(3);














