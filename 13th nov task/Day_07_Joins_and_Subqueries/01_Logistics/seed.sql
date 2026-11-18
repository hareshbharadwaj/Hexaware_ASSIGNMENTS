USE day7_logistics;

INSERT INTO hubs VALUES
(1,'Chennai Central','Chennai'),(2,'Bengaluru Hub','Bengaluru'),
(3,'Hyderabad Hub','Hyderabad'),(4,'Coimbatore Hub','Coimbatore');

INSERT INTO carriers VALUES
(1,'SwiftLine'),(2,'BlueRoute'),(3,'CargoMax');

INSERT INTO customers VALUES
(1,'Aarav Stores','Chennai'),(2,'Meera Traders','Bengaluru'),
(3,'Nova Retail','Hyderabad'),(4,'Kavin Supplies','Coimbatore'),
(5,'Orbit Mart','Chennai');

INSERT INTO employees VALUES
(1,'Ravi Kumar',1,NULL),(2,'Anitha Raj',1,1),(3,'Vikram Das',2,1),
(4,'Divya S',3,1),(5,'Arun P',4,3);

INSERT INTO shipments VALUES
(101,1,1,1,2,2,'2026-10-01','2026-10-03','2026-10-06',850.00),
(102,2,2,2,3,3,'2026-10-02','2026-10-05','2026-10-05',620.00),
(103,3,1,3,1,4,'2026-10-03','2026-10-05','2026-10-09',940.00),
(104,1,3,1,3,2,'2026-10-04','2026-10-07','2026-10-07',780.00),
(105,4,2,4,1,5,'2026-10-05','2026-10-08','2026-10-08',540.00),
(106,2,1,2,1,3,'2026-10-06','2026-10-08','2026-10-12',710.00),
(107,3,3,3,2,4,'2026-10-07','2026-10-10',NULL,1100.00),
(108,5,2,1,4,2,'2026-10-08','2026-10-11','2026-10-11',460.00),
(109,4,1,4,2,5,'2026-10-09','2026-10-12','2026-10-15',690.00);

INSERT INTO delivery_events VALUES
(1,101,'PICKED_UP','2026-10-01 09:00:00','Collected at origin'),
(2,101,'DELIVERED','2026-10-06 15:00:00','Delivered late'),
(3,102,'DELIVERED','2026-10-05 12:00:00','On time'),
(4,103,'DELAYED','2026-10-07 10:00:00','Weather delay'),
(5,103,'DELIVERED','2026-10-09 17:00:00','Delivered'),
(6,106,'DELAYED','2026-10-10 11:00:00','Vehicle issue'),
(7,106,'DELIVERED','2026-10-12 16:00:00','Delivered'),
(8,107,'IN_TRANSIT','2026-10-09 08:00:00','In transit');
