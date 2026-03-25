create schema ss7b2;
create table ss7b2.customer (
customer_id serial primary key,
full_name varchar(100),
email varchar(100),
phone varchar(15)
);
create table ss7b2.orders (
order_id serial primary key,
customer_id int references ss7b2.customer(customer_id),
total_amount decimal(10,2),
order_date date
);

insert into ss7b2.customer (full_name, email, phone) values
('Nguyễn Văn A', 'a@gmail.com', '0912345678'),
('Trần Thị B', 'b@example.com', '0988776655'),
('Lê Văn C', 'c@outlook.com', '0909090909');
insert into ss7b2.orders (customer_id, total_amount, order_date) values
(1, 1500000, '2026-03-01'),
(1, 500000, '2026-03-15'),
(2, 2000000, '2026-03-20'),
(3, 800000, '2026-03-25');

create or replace view ss7b2.v_order_summary as
select 
c.full_name, 
o.total_amount, 
o.order_date
from ss7b2.customer c join ss7b2.orders o on c.customer_id = o.customer_id;
select * from ss7b2.v_order_summary;
create or replace view ss7b2.v_high_value_orders as select * from ss7b2.orders where total_amount >= 1000000;
update ss7b2.v_high_value_orders set total_amount = 1600000 where order_id = 1;
select * from ss7b2.v_high_value_orders;
select * from ss7b2.orders;
create or replace view ss7b2.v_monthly_sales as
select 
to_char(order_date, 'yyyy-mm') as month, 
sum(total_amount) as total_revenue from ss7b2.orders group by to_char(order_date, 'yyyy-mm');
select * from ss7b2.v_monthly_sales;
drop view if exists ss7b2.v_order_summary;

/* sự khác biệt:
- drop view: xóa một view ảo (không lưu trữ dữ liệu thực tế). khi xóa chỉ mất định nghĩa câu lệnh sql, không giải phóng không gian bộ nhớ đáng kể.
- drop materialized view: xóa một view vật lý (có lưu trữ dữ liệu thực tế trên đĩa). khi xóa sẽ giải phóng không gian bộ nhớ mà dữ liệu của view đó đang chiếm giữ.
*/