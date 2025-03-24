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
