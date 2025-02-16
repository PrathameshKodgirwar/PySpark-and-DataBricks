Use AdventureWorks2019;

---1. A) Find first 20 employees who joined very early in the company.
Select * from Person.Person;
Select* from HumanResources.Employee
Select Top 20(Select FirstName From Person.Person Where Person.BusinessEntityID =
Employee.BusinessEntityID) First_name,
(Select LastName From Person.Person Where Person.BusinessEntityID = Employee.BusinessEntityID)
Last_name,
HireDate
From HumanResources.Employee
Order By HireDate Asc;

---1. B) Find all employees name , job title, card details whose credit card expired in the month 9 and year as 2009
select * from HumanResources.Employee
Select* from Sales.PersonCreditCard
select * from Sales.CreditCard
Select
(Select FirstName From Person.Person Where Person.BusinessEntityID = Employee.BusinessEntityID)
as First_Name,
(Select LastName From Person.Person Where Person.BusinessEntityID = Employee.BusinessEntityID)
as Last_Name, JobTitle,
(Select CreditCardID From Sales.PersonCreditCard Where PersonCreditCard.BusinessEntityID =
Employee.BusinessEntityID) AS Card_ID
From HumanResources.Employee
Where Employee.BusinessEntityID IN (
Select CreditCardID From Sales.CreditCard
Where ExpYear= 2009 And ExpMonth = 9
);

---1 C. Find the store address and contact number based on tables store and Business entity check if any other table is required.
Select * from Sales.Store;
Select * from Person.Address;
Select * from Person.BusinessEntityAddress;
Select
(Select Name From Sales.Store Where Store.BusinessEntityID =
BusinessEntityAddress.BusinessEntityID) Store_Name,
(Select AddressLine1 From Person.Address Where Address.AddressID =
BusinessEntityAddress.AddressID)Store_Address,
(Select PhoneNumber From Person.PersonPhone Where PersonPhone.BusinessEntityID =
BusinessEntityAddress.BusinessEntityID)Phone_Number
From Person.BusinessEntityAddress;

---1 D. check if any employee from job candidate table is having any payment revisions
Select * from HumanResources.JobCandidate;
Select * from Person.Person;
Select * from HumanResources.EmployeePayHistory;
Select
(Select FirstName From Person.Person Where Person.BusinessEntityID =
JobCandidate.BusinessEntityID)as First_name,
(Select LastName From Person.Person Where Person.BusinessEntityID =
JobCandidate.BusinessEntityID)as Last_name
From HumanResources.JobCandidate
Where BusinessEntityID in (Select BusinessEntityID From HumanResources.EmployeePayHistory
Group By BusinessEntityID Having Avg(PayFrequency) > 1);

---E. check colour wise standard cost
Select * From Production.Product;
Select * From Production.ProductCostHistory;
Select Distinct
(Select Color From Production.Product Where Product.ProductID = ProductCostHistory.ProductID) AS
Product_Colour,
Avg(StandardCost) As Avg_StandardCost
From Production.ProductCostHistory
Group By ProductID
Having ProductID In (Select ProductID From Production.Product Where Color Is Not Null);

---F. Which product is purchased more? (purchase order details)
Select * from Production.Product
Select * from Purchasing.PurchaseOrderDetail
Select top 1
(Select Name From Production.Product Where Product.ProductID =
PurchaseOrderDetail.ProductID)Product_Name,
Sum(OrderQty) As Total_Purchased
From Purchasing.PurchaseOrderDetail
Group By ProductID
Order By Total_Purchased Desc;

---G. Find the total values for line total product having maximum order
Select * from Production.Product;
Select * from Sales.SalesOrderDetail;
Select
(Select Name From Production.Product Where Product.ProductID =
SalesOrderDetail.ProductID)Product_Name,
Sum(LineTotal) As Total_Value,sum(OrderQty) As OrderQty
From Sales.SalesOrderDetail Group by ProductID ;

---H. Which product is the oldest product as on the date (refer the product sell start date)
SELECT
(SELECT Name FROM Production.Product WHERE Product.ProductID = P.ProductID)Name,
SellStartDate
FROM Production.Product P
WHERE SellStartDate = (SELECT MIN(SellStartDate) FROM Production.Product);
---I. Find all the employees whose salary is more than the average salary
Select * from HumanResources.EmployeePayHistory

Select BusinessEntityID, Rate As Salary
From HumanResources.EmployeePayHistory
Where Rate > (Select Avg(Rate) 
From HumanResources.EmployeePayHistory);


---J. Display country region code, group average sales quota based on territory id
Select * from Sales.SalesTerritory
Select * from Sales.SalesPerson
 
Select sp.TerritoryID,  
(Select CountryRegionCode From Sales.SalesTerritory st Where st.TerritoryID = sp.TerritoryID) As CountryRegionCode,  
Avg(sp.SalesQuota) As AvgSalesQuota  
From Sales.SalesPerson sp  
Where sp.TerritoryID Is not null  
Group By sp.TerritoryID;


---k. Find the average age of male and female
 Select Gender, Avg(DateDiff(Year, BirthDate, GetDate())) As AvgAge  
From HumanResources.Employee  
JOIN Person.Person On Employee.BusinessEntityID = Person.BusinessEntityID  
Group By Gender;

---L. Which Territory is having more stores ?

Select Top 1 st.Name As TerritoryName, Count(s.BusinessEntityID) As StoreCount
From Sales.Store s
Join Sales.SalesPerson sp On s.SalesPersonID = sp.BusinessEntityID
Join Sales.SalesTerritory st On sp.TerritoryID = st.TerritoryID
Group By st.Name
Order By StoreCount Desc;


---M. Check for sales person details which are working in Stores (find the sales person ID)
Select Distinct sp.BusinessEntityID As SalesPersonID
From Sales.SalesPerson sp
Where sp.BusinessEntityID IN (
    Select s.SalesPersonID From Sales.Store s Where s.SalesPersonID Is not null);

---N. display the product name and product price and count of product cost revised (productcosthistory)

Select p.Name As ProductName, p.ListPrice, 
(Select Count(*) From Production.ProductCostHistory pch 
Where pch.ProductID = p.ProductID) As CostRevisionCount
From Production.Product p;


---O. check the department having more salary revision
Select * from HumanResources.EmployeePayHistory;
Select * from HumanResources.Department;
Select * From HumanResources.Employee;
Select
d.Name As DepartmentName, Count(eph.BusinessEntityID) As SalaryRevisions
From HumanResources.EmployeePayHistory eph
Join HumanResources.Employee e ON eph.BusinessEntityID = e.BusinessEntityID JOIN
HumanResources.EmployeeDepartmentHistory edh ON e.BusinessEntityID = edh.BusinessEntityID
Join HumanResources.Department d ON edh.DepartmentID = d.DepartmentID
Group By d.Name Order By SalaryRevisions Desc;