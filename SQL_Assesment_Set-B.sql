Use AdventureWorks2019;

---1. Find Employee with the Highest Rate or Highest Pay Frequency

Select TOP 1 BusinessEntityID, Rate, PayFrequency  
From HumanResources.EmployeePayHistory  
Order By Rate DESC, PayFrequency DESC
---2. Analyze Inventory Based on Shelf Wise Count of the Product and Their Quantity

Select Shelf, COUNT(ProductID) AS ProductCount, SUM(Quantity) AS TotalQuantity  
From Production.ProductInventory  
Group By Shelf  
Order By TotalQuantity DESC
---3. Find Personal Details with Address and Address Type

(Select p.BusinessEntityID, p.FirstName, p.LastName, a.AddressLine1, a.City, at.Name AS AddressType  
From Person.Person p  
Join Person.BusinessEntityAddress bea ON p.BusinessEntityID = bea.BusinessEntityID  
Join Person.Address a ON bea.AddressID = a.AddressID  
Join Person.AddressType at ON bea.AddressTypeID = at.AddressTypeID)

---4. Find the Job Title Having More Revised Payments

Select e.JobTitle, COUNT(ep.RateChangeDate) AS RevisedPaymentCount  
From HumanResources.Employee e  
Join HumanResources.EmployeePayHistory ep ON e.BusinessEntityID = ep.BusinessEntityID  
Group By e.JobTitle  
Order By RevisedPaymentCount DESC
---5. Display Special Offer Description, Category, and Avg(DiscountPct) Per Month

Select so.Description, pc.Name AS Category, AVG(soh.TotalDue * so.DiscountPct) AS AvgDiscountPerMonth  
From Sales.SpecialOffer so  
Join Sales.SalesOrderHeader soh ON so.SpecialOfferID = soh.SalesOrderID  
Join Production.ProductSubcategory ps ON ps.ProductSubcategoryID = so.SpecialOfferID  
Join Production.ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID  
Group By so.Description, pc.Name, YEAR(soh.OrderDate), MONTH(soh.OrderDate)  
Order By AvgDiscountPerMonth DESC

---6. Using Rank and Dense Rank, Find Territory-Wise Top Sales Person

Select p.BusinessEntityID AS SalesPersonID,  
        CONCAT(p.FirstName, ' ', p.LastName) AS SalesPersonName,  
        sp.TerritoryID,  
        sp.SalesYTD,  
        RANK() OVER (PARTITION BY sp.TerritoryID ORDER BY sp.SalesYTD DESC) AS RankPosition,  
        DENSE_RANK() OVER (PARTITION BY sp.TerritoryID ORDER BY sp.SalesYTD DESC) AS DenseRankPosition  
From Sales.SalesPerson sp  
Join Person.Person p ON sp.BusinessEntityID = p.BusinessEntityID


---7. Calculate Total Years of Experience and Find Employees Who Served for More Than 20 Years

Select BusinessEntityID, DATEDIFF(YEAR, HireDate, GETDATE()) AS YearsOfExperience  
From HumanResources.Employee  
Where DATEDIFF(YEAR, HireDate, GETDATE()) > 20
---8. Find Employees Who Have More Vacations Than the Average Vacation Taken by All Employees

Select BusinessEntityID, VacationHours  
From HumanResources.Employee  
Where VacationHours > (Select AVG(VacationHours) From HumanResources.Employee)
---9. Find the Department Name Having More Employees

Select d.Name AS DepartmentName, COUNT(e.BusinessEntityID) AS EmployeeCount  
From HumanResources.EmployeeDepartmentHistory edh  
Join HumanResources.Department d ON edh.DepartmentID = d.DepartmentID  
Join HumanResources.Employee e ON edh.BusinessEntityID = e.BusinessEntityID  
Group By d.Name  
Order By EmployeeCount DESC
---10. Check If Any Person Has More Than One Credit Card

Select BusinessEntityID, COUNT(CreditCardID) AS CreditCardCount  
From Sales.PersonCreditCard  
Group By BusinessEntityID  
Having COUNT(CreditCardID) > 1
---11. Find How Many Subcategories Are Available Per Product

Select ps.Name AS SubCategory, COUNT(p.ProductID) AS ProductCount  
From Production.Product p  
Join Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID  
Group By ps.Name  
Order By ProductCount DESC
---12. Find Total Standard Cost for the Active Products Where End Date Is Not Updated

Select SUM(StandardCost) AS TotalStandardCost  
From Production.ProductCostHistory  
Where EndDate IS NULL
---13. Find Which Territory Has More Customers

Select TerritoryID, COUNT(CustomerID) AS CustomerCount  
From Sales.Customer  
Group By TerritoryID  
Order By CustomerCount DESC