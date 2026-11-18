USE day7_retail_returns;
INSERT INTO regions VALUES
(1,'South'),(2,'West'),(3,'North');
INSERT INTO stores VALUES
(1,'Chennai Express',1),(2,'Bengaluru Square',1),
(3,'Mumbai Central',2),(4,'Delhi Market',3);
INSERT INTO customers VALUES
(1,'Isha'),(2,'Jeevan'),(3,'Kiran'),(4,'Latha'),(5,'Mohan');
INSERT INTO products VALUES
(1,'Wireless Mouse','Electronics'),(2,'Keyboard','Electronics'),
(3,'Office Chair','Furniture'),(4,'Water Bottle','Lifestyle'),
(5,'Desk Lamp','Home');
INSERT INTO employees VALUES
(1,'Ramesh',1,NULL),(2,'Sowmya',1,1),(3,'Naveen',2,1),
(4,'Pooja',3,1),(5,'Ajay',4,4);
INSERT INTO orders VALUES
(301,1,1,2,'2026-09-01'),(302,2,1,2,'2026-09-03'),
(303,3,2,3,'2026-09-05'),(304,1,3,4,'2026-09-08'),
(305,4,4,5,'2026-09-10'),(306,5,2,3,'2026-09-12'),
(307,2,3,4,'2026-09-15'),(308,3,1,2,'2026-09-18');
INSERT INTO order_items VALUES
(1,301,1,2,500.00),(2,301,2,1,900.00),
(3,302,3,1,5000.00),(4,303,1,1,500.00),
(5,303,4,3,200.00),(6,304,3,2,5000.00),
(7,305,5,1,1200.00),(8,306,2,2,900.00),
(9,307,1,1,500.00),(10,308,4,2,200.00);
INSERT INTO returns VALUES
(401,1,'2026-09-10',1,'Defective'),(402,3,'2026-09-12',1,'Damaged'),
(403,5,'2026-09-20',1,'Changed mind'),(404,6,'2026-09-22',1,'Defective'),
(405,8,'2026-09-25',1,'Wrong item'),(406,9,'2026-09-28',1,'Defective');
INSERT INTO refunds VALUES
(501,401,500.00,'2026-09-15','PAID'),
(502,402,5000.00,NULL,'PENDING'),
(503,403,200.00,'2026-09-25','PAID'),
(504,404,5000.00,'2026-09-30','PAID'),
(505,405,900.00,NULL,'PENDING');
