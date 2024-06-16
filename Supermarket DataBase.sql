create database mart;
use mart;

# 1. creating customer table
create table customers(
customerid varchar(100) primary key,
customername varchar(150),
gender char(2),
address varchar(255),
email varchar(255),
number varchar(100),
registrationdate date);

# 2. creating category table
create table categories(
categoryid varchar(255) primary key,
categories varchar(255));

# 3. creating coupons table
create table coupons(
couponid varchar(255) primary key,
couponcode varchar(255),
discount varchar(255),
expirydate date,
status varchar(255));

# 4. creating employee table
create table employees(
employeeid varchar(255) primary key,
position varchar(255),
storeid int,
hiredate date);

# 5. creating redemptions table
create table redemptions(
redemptionid varchar(255) primary key,
customerid varchar(255),
usedcouponid varchar(255),
redemptiondate date);

# 6.  creating supplier table
create table suplier(
supplierid varchar(255) primary key,
categoryid varchar(255),
supplierlocation varchar(255),
SupplierPhone varchar(255),
SupplierMailIDs varchar(255));

# 7. creating transactions table
create table transactions(
TransactionID int auto_increment primary key,
CustomerID varchar(255),
PurchaseAmount int,
PurchaseDate date,
PurchaseTime time,
ProductID varchar(255),
PurchaseQuantity int);

# 8. Creating feedback table
create table feedback(
FeedbackID varchar(255) primary key,
CustomerID varchar(255),
FeedbackDate date,
Feedback text,
Ratings int);

# 9. Creating products table 
create table products(
ProductID varchar(255) primary key,
CategoryID varchar(255),
Categories varchar(255),
Products varchar(255),
Prices float,
StockQuantity int);


# Easy Level Questions
# 1. Retrieve the details of all customers from the Customers table.
select * from customers;

# 2. List all transactions along with the corresponding customer details (CustomerName, PurchaseDate, PurchaseAmount). 
select 
c.CustomerName,
t.transactionid, 
t.PurchaseDate, 
t.PurchaseAmount
from transactions t
left join customers c
on t.customerid = c.customerid;

# 3. Display the FeedbackID, FeedbackDate, and Ratings for all feedback entries.
select feedbackid, feedbackdate, ratings
from feedback;

# 4. Show the RedemptionID, UsedCouponID, and RedemptionDate for all redemptions
select redemptionid, usedcouponid, redemptiondate
from redemptions;

# 5. List all categories available in the Categories table.
select categories
from categories;

# 6. Display all products along with their respective prices from the Products table.
select products, prices
from products;

# 7. Show the SupplierName and SupplierLocation for all suppliers.
select suppliername, supplierlocation
from suppliers;

# 9. Display the EmployeeName and Position for all employees.
select distinct(employeename), position, hiredate
from employees;

# 10. Retrieve all transactions with a PurchaseAmount greater than 100.
select 
count(transactionid) as transactions,
purchaseamount
from transactions
where purchaseamount > 100
group by transactionid;

# 11. Show the total number of transactions made by each customer.
select 
c.customername,
c.email,
c.number,
c.address,
count(t.transactionid) as num_transactions
from customers c
join transactions t
on c.customerid = t.customerid
group by c.customername,
c.email, 
c.number,
c.address 
order by num_transactions desc;

# 12. Write a query to get customer details who made transaction amount greater than 100 dollars and add
create view CustomerTransactionSummary as 
select 
   c.customername,
   c.email,
   c.number,
   c.address,
   sum(t.purchaseamount) as transaction_amount
from customers c
join transactions t
on c.customerid = t.customerid
where purchaseamount > 100
group by 
   c.customername,
   c.email, 
   c.number,
   c.address 
 order by transaction_amount desc;
 
 select * from customertransactionsummary; # high priority customers to offer any updates or discounts
 
# 13. Display the names of all products that are high and low in stock 
select 
products
high_stock_status,
low_stock_status
from 
(select products,
case 
    when max(stockquantity) >= 50 then 'High Stock' 
    else null
end as high_stock_status,
case
when min(stockquantity) <= 10 then 'Low Stock'
 else null 
 end as low_stock_status
from products
group by products)t;

# 14. List the categories along with the count of products in each category.
select c.categories, count(p.products) as num_products
from categories c
join products p
on c.categoryid = p.categoryid
group by c.categories
order by num_products;

# 15. Retrieve the EmployeeName and Position for employees hired this year.
select employeename
from employees
where year(hiredate) = 2024;

select employeename, max(year(hiredate)) - min(year(hiredate)) as num_years
from employees
group by employeename
order by num_years desc;

# Medium Level Questions
# 1. List the top 5 customers (CustomerName) based on their total PurchaseAmount.
select customername
from customertransactionsummary
group by customername, transaction_amount
order by transaction_amount desc
limit 5;

/* 2. Show the most recent feedback along with the corresponding customer details 
(CustomerName, FeedbackDate, Feedback) */

create view NegativeCustomers as 
select c.customername, year(f.feedbackdate) as feedback_year, f.feedback, f.ratings
from feedback f
join customers c
on f.customerid = c.customerid
where year(feedbackdate) = 2024 and ratings <3
order by ratings asc;

# 3. Display the total DiscountAmount redeemed by each customer.
select c.customerName,
 sum(r.discountamount) as total_discounts,
 sum(case when year(r.redemptiondate) = 2022 then r.discountamount else 0 end)  as discounts_2022,
 sum(case when year(r.redemptiondate) = 2023 then r.discountamount else 0 end) as discounts_2023,
 sum(case when year(r.redemptiondate) = 2024 then r.discountamount else 0 end) as discount_2024
 
from redemptions r
join customers c
on r.customerid = c.customerid
group by  c.customerName;

# extracting last 3 years discounts amounts
select 
month(redemptiondate) as monthwise_discounts,
sum(case when year(redemptiondate) = 2022 then discountamount else 0 end) as discounts_2022,
sum(case when year(redemptiondate) = 2023 then discountamount else 0 end) as discounts_2023,
sum(case when year(redemptiondate) = 2024 then discountamount else 0 end) as discounts_2024

from redemptions
group by monthwise_discounts
order by monthwise_discounts;

# Product Performance monthly
with cte as(
select productid, purchaseamount, month(purchasedate) as monthly_sales,
sum(case when year(purchasedate) = 2017 then purchaseamount else 0 end) as '2017_sales',
sum(case when year(purchasedate) = 2018 then purchaseamount else 0 end) as '2018_sales',
sum(case when year(purchasedate) = 2019 then purchaseamount else 0 end) as '2019_sales',
sum(case when year(purchasedate) = 2020 then purchaseamount else 0 end) as '2020_sales',
sum(case when year(purchasedate) = 2021 then purchaseamount else 0 end) as '2021_sales',
sum(case when year(purchasedate) = 2022 then purchaseamount else 0 end) as '2022_sales',
sum(case when year(purchasedate) = 2023 then purchaseamount else 0 end) as '2023_sales',
sum(case when year(purchasedate) = 2024 then purchaseamount else 0 end) as '2024_sales'
from transactions
group by productid, purchaseamount, monthly_sales
order by monthly_sales asc)

select * from cte;

# product performance yearly
with cte as(
select productid, purchaseamount as sales,
sum(case when year(purchasedate) = 2017 then purchaseamount else 0 end) as '2017_sales',
sum(case when year(purchasedate) = 2018 then purchaseamount else 0 end) as '2018_sales',
sum(case when year(purchasedate) = 2019 then purchaseamount else 0 end) as '2019_sales',
sum(case when year(purchasedate) = 2020 then purchaseamount else 0 end) as '2020_sales',
sum(case when year(purchasedate) = 2021 then purchaseamount else 0 end) as '2021_sales',
sum(case when year(purchasedate) = 2022 then purchaseamount else 0 end) as '2022_sales',
sum(case when year(purchasedate) = 2023 then purchaseamount else 0 end) as '2023_sales',
sum(case when year(purchasedate) = 2024 then purchaseamount else 0 end) as '2024_sales'
from transactions
group by productid, purchaseamount)

select * from cte;

# total sales year wise
with cte as(
select 
sum(case when year(purchasedate) = 2017 then purchaseamount else 0 end) as '2017_sales',
sum(case when year(purchasedate) = 2018 then purchaseamount else 0 end) as '2018_sales',
sum(case when year(purchasedate) = 2019 then purchaseamount else 0 end) as '2019_sales',
sum(case when year(purchasedate) = 2020 then purchaseamount else 0 end) as '2020_sales',
sum(case when year(purchasedate) = 2021 then purchaseamount else 0 end) as '2021_sales',
sum(case when year(purchasedate) = 2022 then purchaseamount else 0 end) as '2022_sales',
sum(case when year(purchasedate) = 2023 then purchaseamount else 0 end) as '2023_sales',
sum(case when year(purchasedate) = 2024 then purchaseamount else 0 end) as '2024_sales'
from transactions)
select * from cte;

# Let's extract feedbacks with the word "best" in it
select c.customername, f.feedback, f.ratings
from feedback f
left join customers c
on f.customerid = c.customerid
where feedback like '%best%';

# let's extract the feedback with the word "worst" in it
select c.customername, f.feedback, f.ratings
from feedback f
left join customers c
on f.customerid = c.customerid
where feedback like '%worst%';
/* insight: most of the reviews are of 1 stars */

# let's count total number of negative and postive ratings
with negative as
(select c.customername, f.feedback, f.ratings
from feedback f
left join customers c
on f.customerid = c.customerid
where feedback like '%worst%')
select
count(case when ratings = 1 then ratings else 0 end) as '1_star_reviews',
count(case when ratings = 2 then ratings else 0 end) as '2_star_reviews',
count(case when ratings = 3 then ratings else 0 end) as 'neutral_reviews(3-star)',
count(case when ratings > 3 then ratings else 0 end) as 'Postive_reviews(4,5-stars)'
from negative;

# let's extract purcasequantity

select c.customername, t.purchaseamount, t.purchasequantity
from transactions t
left join customers c
on t.customerid = c.customerid
order by t.purchasequantity desc;

# most busy hours

SELECT 
    DATE_FORMAT(purchasetime, '%r') AS busyhours, sum(purchaseamount)
FROM 
    transactions
group by busyhours
order by sum(purchaseamount) desc;

# most busy hours per year
SELECT 
DATE_FORMAT(purchasetime, '%r') AS busyhours,
sum(case when year(purchasedate) = 2017 then purchaseamount else 0 end) as '2017_sales',
sum(case when year(purchasedate) = 2018 then purchaseamount else 0 end) as '2018_sales',
sum(case when year(purchasedate) = 2019 then purchaseamount else 0 end) as '2019_sales',
sum(case when year(purchasedate) = 2020 then purchaseamount else 0 end) as '2020_sales',
sum(case when year(purchasedate) = 2021 then purchaseamount else 0 end) as '2021_sales',
sum(case when year(purchasedate) = 2022 then purchaseamount else 0 end) as '2022_sales',
sum(case when year(purchasedate) = 2023 then purchaseamount else 0 end) as '2023_sales',
sum(case when year(purchasedate) = 2024 then purchaseamount else 0 end) as '2024_sales'
FROM 
    transactions
group by busyhours;

# sales by each day and month
select day(purchasedate) as days, month(purchasedate) as month_number,
sum(purchaseamount) as sales
from transactions
group by month_number ,days
order by days, month_number asc;

# Show the average rating for feedback received in each month of the year.

select avg(f.ratings) as avg_ratings, month(t.purchasedate) as monthly,
year(t.purchasedate) as years
from feedback f
left join customers c
on f.customerid = c.customerid
join transactions t
on c.transactionid = t.transactionid

group by monthly, years
order by monthly asc;

# select second highest year in sales
select sum(purchaseamount) as sales, year(purchasedate) as years
from transactions 
group by years
order by sales desc
limit 1 offset 3;

# List the products that have been purchased more than 10 times.
select productid, count(productid)
from transactions
group by productid
having count(productid) > 10
order by count(productid) desc;  # cold and flu medicines are the top most purchased products

# Hard Level Questions
/* 1. Retrieve the CustomerName and total PurchaseAmount for customers who made purchases 
in each month of the current year.*/

select c.customername, sum(t.purchaseamount) as sales, 
month(purchasedate) as monthly , year(purchasedate) as current_year
from transactions t
left join customers c
on c.customerid = t.customerid
where year(purchasedate) = 2024
group by c.customername, purchasedate
order by monthly asc;

# List the customers who have never given any feedback.
select c.customername, f.feedback
from feedback f
left join customers c
on c.customerid = f.customerid
where f.customerid is null;

# Show the top 3 products (ProductID) with the highest total PurchaseQuantity.
select productid, sum(purchasequantity) as total
from transactions
group by productid
order by total desc
limit 3;

# Calculate the total DiscountAmount redeemed by customers who have made purchases totaling more than $1000.
select c.customername as customers, sum(r.discountamount) as discouts, t.purchaseamount
from redemptions r
left join customers c
on r.customerid = c.customerid
left join transactions t
on r.customerid = t.customerid
where t.purchaseamount > 1000
group by customers, t.purchaseamount
order by t.purchaseamount;

# Retrieve the categories that have a lower stock quantity than the average stock quantity of all products
select categories
from
(select c.categories, sum(p.stockquantity) as total_stock, avg(p.stockquantity) average_stock
from products p
left join categories c
on c.categoryid = p.categoryid
group by c.categories)t
where total_stock < average_stock;

/* Retrieve the details of transactions where the PurchaseQuantity 
is higher than the average PurchaseQuantity for all transactions.*/

select * from transactions
where purchasequantity > (select avg(purchasequantity) from transactions)
order by purchasequantity desc;

/*Show the monthly revenue generated from each category for the current year. */
 
 select sum(purchaseamount) as revenue, month(purchasedate)
 from transactions
 where year(purchasedate) = 2024
 group by month(purchasedate);
 
 