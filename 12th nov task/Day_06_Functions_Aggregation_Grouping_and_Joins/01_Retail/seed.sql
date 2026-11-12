USE day6_retail;
INSERT INTO customers VALUES
(1,'Ananya Rao','Chennai','ananya@example.com','2025-01-10'),
(2,'Karthik Kumar','Bengaluru','karthik@example.com','2025-02-15'),
(3,'Meera Shah','Chennai','meera@example.com','2025-03-20'),
(4,'Arjun Nair','Kochi','arjun@example.com','2025-04-05'),
(5,'Divya Iyer','Madurai','divya@example.com','2025-05-12');
INSERT INTO products VALUES
(101,'Wireless Mouse','Accessories',799.00),(102,'Mechanical Keyboard','Accessories',2499.00),
(103,'USB-C Hub','Electronics',1899.00),(104,'Laptop Stand','Accessories',1299.00),
(105,'Webcam','Electronics',3299.00);
INSERT INTO orders VALUES
(1001,1,'2026-10-01','PAID'),(1002,1,'2026-10-05','PENDING'),
(1003,2,'2026-10-05','PAID'),(1004,2,'2026-10-12','PAID'),
(1005,3,'2026-10-12','UNPAID'),(1006,1,'2026-11-01','PAID'),
(1007,4,'2026-11-02','PAID'),(1008,2,'2026-11-02','PAID');
INSERT INTO order_items VALUES
(1,1001,101,2,799),(2,1001,102,1,2499),(3,1002,103,1,1899),
(4,1003,101,1,799),(5,1003,104,2,1299),(6,1004,105,1,3299),
(7,1005,103,2,1899),(8,1006,102,1,2499),(9,1006,101,1,799),
(10,1007,104,1,1299),(11,1008,105,2,3299);
