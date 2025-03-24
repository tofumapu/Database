CREATE DATABASE SERVICEPROVIDER
USE SERVICEPROVIDER

CREATE TABLE ServiceProviders(
	ProviderID int PRIMARY KEY,
	Name nvarchar(255),
	Contact nvarchar(100),
	Address nvarchar(max),
	CreatedAt datetime,
	IsDeleted bit
)

CREATE TABLE Services(
	ServiceID int PRIMARY KEY,
	ProviderID int,
	ServiceName nvarchar(255),
	Description nvarchar(max),
	Price decimal(10, 2),
	CreatedAt datetime,
	IsDeleted bit,
	CONSTRAINT FK_SERVICES_SERVICESPROVIDER FOREIGN KEY(ProviderID) REFERENCES ServiceProviders(ProviderID)
)

CREATE TABLE Customers(
	CustomerID int PRIMARY KEY,
	Name nvarchar(255),
	Email nvarchar(100),
	Phone nvarchar(20),
	Address nvarchar(max),
	CreatedAt datetime,
	IsDeleted bit
)

CREATE TABLE Bookings(
	BookingID int PRIMARY KEY,
	CustomerID int,
	ServiceID int,
	BookingDate datetime,
	Status nvarchar(50),
	CreatedAt datetime,
	IsDeleted bit,
	CONSTRAINT FK_BOOKINGS_CUSTOMERS FOREIGN KEY(CustomerID) REFERENCES Customers(CustomerID),
	CONSTRAINT FK_BOOKINGS_SERVICES FOREIGN KEY(ServiceID) REFERENCES Services(ServiceID)
)

CREATE TABLE Reviews(
	ReviewID int PRIMARY KEY,
	CustomerID int,
	ServiceID int,
	Rating int,
	Comments nvarchar(max),
	CreatedAt datetime,
	IsDeleted bit,
	CONSTRAINT FK_Reviews_CUSTOMERS FOREIGN KEY(CustomerID) REFERENCES Customers(CustomerID),
	CONSTRAINT FK_Reviews_SERVICES FOREIGN KEY(ServiceID) REFERENCES Services(ServiceID)
)
INSERT INTO ServiceProviders (ProviderID, Name, Contact, Address, CreatedAt, IsDeleted)
VALUES 
(1, 'Provider 1', 'Contact 1', 'Address 1', GETDATE(), 0),
(2, 'Provider 2', 'Contact 2', 'Address 2', GETDATE(), 0),
(3, 'Provider 3', 'Contact 3', 'Address 3', GETDATE(), 0),
(4, 'Provider 4', 'Contact 4', 'Address 4', GETDATE(), 0),
(5, 'Provider 5', 'Contact 5', 'Address 5', GETDATE(), 0);
INSERT INTO Services (ServiceID, ProviderID, ServiceName, Description, Price, CreatedAt, IsDeleted)
VALUES 
(1, 1, 'Service 1', 'Description of Service 1', 100.00, GETDATE(), 0),
(2, 2, 'Service 2', 'Description of Service 2', 150.00, GETDATE(), 0),
(3, 3, 'Service 3', 'Description of Service 3', 200.00, GETDATE(), 0),
(4, 4, 'Service 4', 'Description of Service 4', 250.00, GETDATE(), 0),
(5, 5, 'Service 5', 'Description of Service 5', 300.00, GETDATE(), 0);
INSERT INTO Customers (CustomerID, Name, Email, Phone, Address, CreatedAt, IsDeleted)
VALUES 
(1, 'Customer 1', 'customer1@example.com', '555-0101', 'Address of Customer 1', GETDATE(), 0),
(2, 'Customer 2', 'customer2@example.com', '555-0102', 'Address of Customer 2', GETDATE(), 0),
(3, 'Customer 3', 'customer3@example.com', '555-0103', 'Address of Customer 3', GETDATE(), 0),
(4, 'Customer 4', 'customer4@example.com', '555-0104', 'Address of Customer 4', GETDATE(), 0),
(5, 'Customer 5', 'customer5@example.com', '555-0105', 'Address of Customer 5', GETDATE(), 0);
INSERT INTO Bookings (BookingID, CustomerID, ServiceID, BookingDate, Status, CreatedAt, IsDeleted)
VALUES 
(1, 1, 1, GETDATE(), 'Confirmed', GETDATE(), 0),
(2, 2, 2, GETDATE(), 'Completed', GETDATE(), 0),
(3, 3, 3, GETDATE(), 'Cancelled', GETDATE(), 0),
(4, 4, 4, GETDATE(), 'Pending', GETDATE(), 0),
(5, 5, 5, GETDATE(), 'Confirmed', GETDATE(), 0);
INSERT INTO Reviews (ReviewID, CustomerID, ServiceID, Rating, Comments, CreatedAt, IsDeleted)
VALUES 
(1, 1, 1, 5, 'Excellent service!', GETDATE(), 0),
(2, 2, 2, 4, 'Very good service.', GETDATE(), 0),
(3, 3, 3, 3, 'Service was okay.', GETDATE(), 0),
(4, 4, 4, 2, 'Not satisfied with the service.', GETDATE(), 0),
(5, 5, 5, 5, 'Fantastic experience!', GETDATE(), 0);

-- 2. Xóa những Reviews (cập nhật IsDeleted = 1) với những khách hàng chưa tồn tại đặt Service hoặc 
-- trạng thái đặt Service là chưa hoàn thành (trạng thái khác Completed) (1,0 điểm)
UPDATE Reviews
SET IsDeleted = 1
FROM Reviews A
FULL OUTER JOIN Bookings B on A.CustomerID = B.CustomerID
WHERE B.Status <> 'Completed' OR B.ServiceID = NULL

-- 3. Thực hiện ràng buộc toàn vẹn: “Để đảm bảo rằng mỗi khách hàng chỉ có thể đăng ký tối đa 3 dịch 
-- vụ khác nhau trong một ngày và không có dịch vụ nào bị trùng lặp trong cùng ngày” (2,0 điểm) 
GO
CREATE TRIGGER trg_LimitBookingsPerDay ON Bookings
AFTER INSERT
AS
BEGIN
    DECLARE @CustomerID INT;
    DECLARE @BookingDate DATE;
    SELECT @CustomerID = CustomerID, @BookingDate = CAST(BookingDate AS DATE)
    FROM INSERTED;
    IF (SELECT COUNT(*) FROM Bookings
        WHERE CustomerID = @CustomerID
        AND CAST(BookingDate AS DATE) = @BookingDate) > 3
    BEGIN
        
        RAISERROR('Each customer can only book up to 3 different services per day.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END

SET DATEFORMAT YMD
INSERT INTO Bookings (CustomerID, ServiceID, BookingDate, Status, CreatedAt, 
IsDeleted) 
VALUES 
(1, 1, '2024-12-17', 'Confirmed', GETDATE(), 0), 
(1, 2, '2024-12-17', 'Confirmed', GETDATE(), 0), 
(1, 3, '2024-12-17', 'Confirmed', GETDATE(), 0);

-- Đăng ký dịch vụ thứ 4, điều này sẽ bị từ chối 
INSERT INTO Bookings (CustomerID, ServiceID, BookingDate, Status, CreatedAt, 
IsDeleted) 
VALUES 
(1, 4, '2024-12-17', 'Confirmed', GETDATE(), 0); 

-- Đăng ký dịch vụ thứ 4, điều này sẽ bị từ chối 
INSERT INTO Bookings (CustomerID, ServiceID, BookingDate, Status, CreatedAt, 
IsDeleted) 
VALUES 
(1, 3, '2024-12-17', 'Confirmed', GETDATE(), 0); 
(1, 4, '2024-12-17', 'Confirmed', GETDATE(), 0);
-- 4. Thực hiện ràng buộc toàn vẹn thỏa yêu cầu sau đây: “Những dịch vụ của nhà cung cấp có mã 
-- (ProviderID = 5) thì có giá trên 500.000 đồng” (1,0 điểm) 
ALTER TABLE Services
ADD CONSTRAINT CK_PRICE CHECK (NOT(ProviderID = 5 AND Price <= 500000)) -- $20?

-- 5) Thực hiện các câu truy vấn sau đây trên ngôn ngữ SQL (5,0 điểm)
-- b. Tìm khách hàng đã đặt dịch vụ đắt nhất (tính theo giá trị của dịch vụ) trong mỗi ngày từ 
-- ngày (1/12/2024 đến ngày 18/12/2024) (1,0 điểm) 
SET DATEFORMAT DMY
SELECT BookingDate, B.CustomerID
FROM Customers A
INNER JOIN Bookings B ON A.CustomerID = B.CustomerID
INNER JOIN Services C ON C.ServiceID = B.ServiceID
WHERE PRICE >= ALL (SELECT PRICE 
					 FROM Customers A
					 INNER JOIN Bookings B ON A.CustomerID = B.CustomerID
					 INNER JOIN Services C ON C.ServiceID = B.ServiceID)
	  AND B.BookingDate >= '1/12/2024' AND B.BookingDate <= '18/12/2024'
GROUP BY BookingDate, B.CustomerID
-- a. Tìm khách hàng đăng ký dịch vụ của nhiều nhà cung cấp khác nhau trong cùng một ngày. 
--(1,0 điểm) 
-- d
GO
SELECT C.CustomerID, C.Name, B.ServiceID, B.BookingDate
FROM Customers C
JOIN Bookings B ON B.CustomerID = C.CustomerID 
JOIN Services S ON S.ServiceID = B.ServiceID
WHERE B.BookingDate >= '2024-12-1 00 00 00' AND B.BookingDate < '2024-12-19 00 00 00' 
    AND S.Price >= ALL( SELECT Price
                        FROM Services)
ORDER BY DAY(B.BookingDate)
-- e. Tìm nhà cung cấp cung cấp nhiều dịch vụ nhất và ít dịch vụ nhất (1,0 điểm)
SELECT ProviderID, ServiceID, ServiceCount
FROM (
    SELECT TOP 1 WITH TIES ProviderID, ServiceID, COUNT(ServiceID) AS ServiceCount
    FROM Services
    GROUP BY ProviderID, ServiceID
    ORDER BY COUNT(ServiceID) DESC
) AS A

UNION ALL

SELECT ProviderID, ServiceID, ServiceCount
FROM (
    SELECT TOP 1 WITH TIES ProviderID, ServiceID, COUNT(ServiceID) AS ServiceCount
    FROM Services
    GROUP BY ProviderID, ServiceID
    ORDER BY COUNT(ServiceID) ASC
) AS B;
