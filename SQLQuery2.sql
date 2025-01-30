use AdventureWorks2019;



select count(*) from HumanResources.Employee where Gender='M';

Select count(*) from HumanResources.Employee where SalariedFlag=1;

SELECT * 
FROM HumanResources.Employee 
WHERE VacationHours between 70 and 90;

select * from HumanResources.employee where JobTitle like '%Designer%';

select count(*) from HumanResources.Employee where JobTitle like '%Technician%'

Select NationalIDNumber, JobTitle, MaritalStatus, Gender  from HumanResources.Employee where  JobTitle like '%Marketing%';

select Distinct MaritalStatus from HumanResources.Employee;

select max(VacationHours) from HumanResources.Employee;

Select min(SickLeaveHours) from HumanResources.Employee;

SELECT BusinessEntityID
FROM HumanResources.EmployeeDepartmentHistory 
WHERE DepartmentID IN (
    SELECT DepartmentID 
    FROM HumanResources.Department 
    WHERE GroupName = 'Research and Development'
);

---Display employee details who are working in research and developement---
Select * from HumanResources.Employee where BusinessEntityID in (Select BusinessEntityID from HumanResources.EmployeeDepartmentHistory where DepartmentID in (Select DepartmentID from HumanResources.Department where GroupName='Research and Development'))

---Select all the count of details of employee working in day shift.---

Select count(*) FROM HumanResources.Employee where BusinessEntityID in ( select BusinessEntityID FROM HumanResources.EmployeeDepartmentHistory WHERE ShiftID IN (SELECT ShiftID FROM HumanResources.Shift WHERE Name = 'Day'));
 
 ---Pay frequency should be one---

 select * from HumanResources.Employee where BusinessEntityID in (select BusinessEntityID from HumanResources.EmployeePayHistory where PayFrequency=1);

 ---Find all candidates which are not placed--

 select * from HumanResources.JobCandidate a where a.JobCandidateID not in (Select JobCandidateID from HumanResources.JobCandidate b where BusinessEntityID in (select BusinessEntityID from HumanResources.Employee))

 --- Find address of the person---
 SELECT * FROM Person.Address WHERE AddressID IN (SELECT AddressID FROM Person.BusinessEntityAddress WHERE BusinessEntityID IN (SELECT BusinessEntityID FROM HumanResources.Employee));

  ---Find the name of employee working in group research and developement---
Select FirstName,LastName From Person.Person
Where BusinessEntityID IN
(Select BusinessEntityID From HumanResources.EmployeeDepartmentHistory Where DepartmentID IN
(Select DepartmentID From HumanResources.Department Where GroupName = 'Research and Development'));
