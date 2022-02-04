show databases ;
create database snehil;
use snehil;

CREATE TABLE salesman (     salesman_id int NOT NULL,     name varchar(255) NOT NULL,     city varchar(255),     commission float,     PRIMARY KEY (salesman_id) );

CREATE TABLE Customer (     customer_id int NOT NULL,     cust_name varchar(255) NOT NULL,     city varchar(255) ,     grade int,     salesman_id int,     PRIMARY
KEY (customer_id),     FOREIGN KEY (salesman_id) REFERENCES salesman(salesman_id) );

CREATE TABLE orders (     ord_no int NOT NULL,     purch_amt float,     ord_date date,     customer_id int,     salesman_id int,     PRIMARY KEY (ord_no),     FOREIGN
KEY (salesman_id) REFERENCES salesman(salesman_id),     FOREIGN KEY (customer_id) REFERENCES Customer(customer_id) );

show tables ;

insert into salesman values (5001, "James Hoog", "New York", 0.15);
insert into salesman values (5002, "Nail Knite", "Paris", 0.13);
insert into salesman values (5005, "Pit Alex", "London", 0.11);
insert into salesman values (5006, "Mc Lyon", "Paris", 0.14);
insert into salesman values (5003, "Lauson", "Hen", 0.12);
insert into salesman values (5007, "Paul Adam", "Rome", 0.13);

select * from salesman;

insert into Customer (customer_id, cust_name, city, grade, salesman_id) VALUES (3002, "Nick Rimando",
"New York", 100, 5001);
insert into Customer (customer_id, cust_name, city, grade, salesman_id) VALUES (3005, "Graham Zusi",
"California", 200, 5002);
insert into Customer (customer_id, cust_name, city, grade, salesman_id) VALUES (3001, "Brad Guzan",
"London", NULL, 5005);
insert into Customer (customer_id, cust_name, city, grade, salesman_id) VALUES (3004, "Fabians Johns",
"Paris", 300, 5006);
insert into Customer (customer_id, cust_name, city, grade, salesman_id) VALUES (3007, "Brad Davis",
"New York", 200, 5001);
insert into Customer (customer_id, cust_name, city, grade, salesman_id) VALUES (3008, "Julian Green",
"London", 300, 5002);
insert into Customer (customer_id, cust_name, city, grade, salesman_id) VALUES (3003, "Jozy Altidor",
"Moscow", 200, 5007);

select * from Customer;

insert into orders values (70001, 150.5, '2012-10-05', 3005, 5002);
insert into orders values (70002, 270.65, '2012-09-10', 3001, 5005);
insert into orders values (70003, 65.26, '2012-10-05', 3002, 5001);
insert into orders values (70004, 110.5, '2012-08-17', 3009, 5003);
insert into orders values (70005, 948.5, '2012-09-10', 3005, 5006);
insert into orders values (70006, 2400.6, '2012-07-27', 3007, 5007);
insert into orders values (70007, 5760, '2012-09-10', 3002, 5001);

select * from orders;

# from here query starts

select * from salesman;

select * from Customer;

select * from orders;

#2
select name from salesman;

select commission from salesman;

#3
select ord_date, salesman_id, ord_no, purch_amt from orders ;
#4
select distinct salesman_id from orders;
#5
select name,city from salesman where city="Paris";
#6
select sum(purch_amt) from orders;
#7
select avg(purch_amt) from orders;
#8
select count(distinct salesman_id) from orders;
#9
select count(distinct cust_name) from Customer;
#10
select count(grade) from Customer;
#11
select max(purch_amt) from orders;
select * from orders where purch_amt=(select max(purch_amt) from orders);  #row with max purch_amt
#12
select min(purch_amt) from orders;
select * from orders where purch_amt=(select min(purch_amt) from orders);
#13
select max(grade) as mg, city from Customer group by city ;
#14
select max(purch_amt), customer_id from orders group by customer_id;
#15
select max(purch_amt), ord_date,customer_id from orders group by ord_date,customer_id;
#16
select max(purch_amt),salesman_id from orders where ord_date='2012-09-10' group by salesman_id;
#17
select a.customer_id,a.purch_amt, a.ord_date from orders a inner join (select max(purch_amt) purch_amt,customer_id from orders group by customer_id) b on a.customer_id=b.customer_id and a.purch_amt=b.purch_amt having a.purch_amt>2000;
#18
select a.customer_id,a.purch_amt, a.ord_date from orders a inner join (select max(purch_amt) purch_amt,customer_id from orders group by customer_id) b on a.customer_id=b.customer_id and a.purch_amt=b.purch_amt having a.purch_amt>2000 and a.purch_amt<6000;
#19
select Customer.cust_name,salesman.name,Customer.city from Customer  left join salesman on Customer.salesman_id = salesman.salesman_id where Customer.city=salesman.city;
#20
select orders.ord_no, orders.purch_amt,C.cust_name,C.city from orders  left join Customer C on orders.customer_id = C.customer_id where orders.purch_amt>=500 and orders.purch_amt<=2000;
#21
select C.cust_name, salesman.name from salesman inner join Customer C on salesman.salesman_id = C.salesman_id;
#22
select C.cust_name from salesman inner join Customer C on salesman.salesman_id = C.salesman_id where salesman.commission>0.12;
#23
select Customer.cust_name from Customer  left join salesman on Customer.salesman_id = salesman.salesman_id where Customer.city<>salesman.city and salesman.commission>.12;
#24
select oc.*, salesman.name from
(select o.ord_no,o.ord_date,o.purch_amt,c.customer_id,c.cust_name,c.salesman_id from orders o inner join Customer c on o.customer_id = c.customer_id) oc
left join salesman on salesman.salesman_id=oc.salesman_id;
#25
select cs.salesman_id,cs.customer_id,orders.ord_no from orders right outer join
(select salesman.salesman_id,Customer.customer_id from salesman left join Customer on salesman.salesman_id = Customer.salesman_id) cs
on orders.customer_id=cs.customer_id;
#26
select * from Customer order by cust_name asc ;
#27
select * from Customer where grade<300 order by cust_name asc ;
#28
select c.cust_name,c.city,c.ord_no,c.ord_date,c.purch_amt,c.salesman_id,coalesce(a.num_orders, 0) num_orders from (select count(customer_id) num_orders, customer_id from orders group by customer_id) a
right join
(select Customer.customer_id,Customer.cust_name, Customer.city, orders.ord_no,orders.ord_date,orders.purch_amt,orders.salesman_id from Customer left outer join orders  on Customer.customer_id = orders.customer_id) c
on a.customer_id=c.customer_id;
#29
select co.cust_name, co.city, co.ord_no, co.ord_date,co.purch_amt, salesman.name,salesman.salesman_id
from salesman inner join
(select Customer.cust_name, Customer.city, orders.ord_no,orders.ord_date,orders.purch_amt,coalesce(orders.salesman_id,Customer.salesman_id) salesman_id from Customer left outer join orders  on Customer.customer_id = orders.customer_id) co
where co.salesman_id=salesman.salesman_id;
#30
select salesman.name,COALESCE(co.num_customers, 0) num_customer from salesman left join (select count(customer_id) num_customers,salesman_id from Customer group by salesman_id ) co on co.salesman_id=salesman.salesman_id order by co.num_customers;
#31
select o.* from orders o inner join salesman s on o.salesman_id = s.salesman_id where s.name='Paul Adam';
#32
select o.* from salesman inner join orders o on salesman.salesman_id = o.salesman_id where salesman.city='New York';
#33
select co.ord_no,co.purch_amt,co.ord_date,co.customer_id,co.saleman as salesman_id from salesman inner join(
select o.*,c.salesman_id saleman from orders o inner join Customer c on o.customer_id = c.customer_id where c.customer_id=3007) co
 on co.saleman=salesman.salesman_id
#34
select * from orders
where
orders.purch_amt > (select avg(purch_amt) as mean_amount from orders o where o.ord_date='2012-09-10');
#35
select o.* from salesman inner join
orders o on salesman.salesman_id = o.salesman_id where salesman.city="New York";
#36
select s.salesman_id,commission  from Customer inner join salesman s on Customer.salesman_id = s.salesman_id where Customer.city="Paris";
#37
select * from Customer where (select salesman.salesman_id from salesman where salesman.name="Mc Lyon")-customer_id=2001;
#38
select count(*) as num from Customer where Customer.grade>(select avg(grade) from Customer where city="New York")
#39
select Customer.* from Customer inner join orders o on Customer.customer_id = o.customer_id where o.ord_date='2012-10-05';
#40
select salesman.* from salesman inner join(
select s.salesman_id,count(s.salesman_id) as num_customer from Customer inner join salesman s on Customer.salesman_id = s.salesman_id group by s.salesman_id
having num_customer>1) cs
where cs.salesman_id=salesman.salesman_id;
#41
select * from orders inner join
(select avg(purch_amt) as avg_amt,customer_id from orders group by customer_id) o
where orders.customer_id=o.customer_id having purch_amt>avg_amt;
#42
insert into orders values (70012,412,'2022-02-03',3008,5006);

select * from orders inner join
(select avg(purch_amt) as avg_amt,customer_id from orders group by customer_id) o
where orders.customer_id=o.customer_id having purch_amt>=avg_amt;


















