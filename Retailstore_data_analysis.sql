
--SQL Case Study (Basic) : Retail Data Analysis 


----------------------DATA PREPARATION------------------------------------------

--Q1--BEGIN 

SELECT 'Customer' AS TBL_NAME, count(*) AS NO_OF_RECORDS FROM [dbo].[Customer]
UNION ALL
SELECT 'Prod_cat_info', count(*) FROM [dbo].[prod_cat_info]
UNION ALL
SELECT 'Transactions', count(*) FROM [dbo].[Transactions];

--Q1--END
--Q2--BEGIN 

select
COUNT(*) AS 'Number of Transactions' FROM
(SELECT
CONVERT( FLOAT, total_amt) AS Amount
from
[dbo].[Transactions]
where
CONVERT( FLOAT, total_amt)<0)AS T1;

--Q2--END
--Q3--BEGIN 

select *,convert (datetime,tran_date,103) as New_date 
from [Transactions]
Select*,convert(datetime,DOB,103) As Date_of_Birth from [Customer];

--Q3--END
--Q4--BEGIN 

select
min(tran_Date) AS Start_tran_Date,
max(tran_Date) AS End_tran_Date,
datediff(day,min(tran_Date),max(tran_Date)) as Diff_of_Days,
datediff(month,min(tran_Date),max(tran_Date)) as Diff_of_Months,
datediff(year,min(tran_Date),max(tran_Date)) as Diff_of_Years
from
[Transactions];

--Q4--END
--Q5--BEGIN 

select
prod_subcat,prod_cat
from
prod_cat_info
Where
prod_subcat = 'DIY';

--Q5--END

-------------------------DATA ANALYSIS----------------------------------------------

--Q1--BEGIN 

SELECT TOP(1)
store_type,Count(store_type) as Freq_Trans
from
[Transactions]
group by
store_type
ORDER BY
Count(store_type) DESC;

--Q1--END
--Q2--BEGIN 

SELECT
Gender, count(Gender) as CNT
FROM
[Customer]
WHERE
Gender in('M', 'F') 
GROUP BY
Gender;

--Q2--END

--Q3--BEGIN 

SELECT TOP(1)
city_code,count(customer_id) AS CNT_CUSTOMER
FROM
[Customer]
GROUP BY city_code 
ORDER BY
count(customer_id) DESC;

--Q3--END

--Q4 --BEGIN 
select
prod_cat AS CATEGORY, count(prod_subcat) AS CNT_SUB_CAT
FROM
[prod_cat_info]
where
prod_cat = 'Books'
group by prod_cat;

--Q4--END
--Q5 --BEGIN 

select TOP(1)
cust_id,sum(Qty) as Qty_ordered
from
[Transactions]
group by
cust_id
order by 
sum(Qty) desc;

--Q5--END
--Q6--BEGIN 

select
T1.prod_cat as Category,ROUND(sum(total_amt), 1) AS  Net_revenue
from
[prod_cat_info] T1
Left join [Transactions] T2 ON T1.prod_cat_code = T2.prod_cat_code and T1.prod_sub_cat_code = T2.prod_subcat_code
where
prod_cat in( 'Electronics', 'Books')
group by
T1.prod_cat;

--Q6--END
--Q7--BEGIN 

select
cust_id as Customer, count(transaction_id) as CNT_Tran
from
[Transactions]
where
total_amt>=0
group by
cust_id
Having
count(transaction_id) >10
order by
count(transaction_id) desc;

--Q7--END
--Q8--BEGIN 

select
Store_type,ROUND(sum(total_amt), 1) AS  Combined_revenue
from
[prod_cat_info] T1
Left join [Transactions] T2 ON T1.prod_cat_code = T2.prod_cat_code and T1.prod_sub_cat_code = T2.prod_subcat_code
where
store_type = 'Flagship store'AND prod_cat in( 'Electronics', 'Clothing')
group by
Store_type;

--Q8--END
--Q9--BEGIN 

select
prod_subcat,ROUND(sum(total_amt), 1) AS  Tot_revenue
from
[prod_cat_info] T1
Left join [Transactions] T2 ON T1.prod_cat_code = T2.prod_cat_code and T1.prod_sub_cat_code = T2.prod_subcat_code
Left join [Customer] T3 ON T2.cust_id = T3.customer_Id
where
Gender = 'M'AND prod_cat =  'Electronics'
group by
prod_subcat;

--Q9--END
--Q10--BEGIN 

Select TOP(5)
prod_subcat as 'Subcategory' ,
sum (case when total_amt > 0 then total_amt else 0 end ) / (SELECT SUM(total_amt) FROM Transactions)*100 [%_Sales],
sum (case when total_amt < 0 then total_amt else 0 end ) / (SELECT SUM(total_amt) FROM Transactions)*100 [%_Returns]
from
[Transactions] T1
Left join [prod_cat_info] T2 ON T1.prod_cat_code = T2.prod_cat_code AND prod_sub_cat_code = prod_subcat_code
group by
prod_subcat
order by
[%_Sales] desc;

--Q10--END
--Q11--BEGIN 

select
datediff( year, DOB, getdate()) as Age, sum(total_amt) as Net_Revenue
from
[Customer] T1 
Left join [Transactions] T2 on customer_Id = cust_id
where
(datediff( year, DOB, getdate()) BETWEEN 25 AND 35) and tran_date > dateadd( day,-30, (Select max (tran_date) From [Transactions]))
group by
datediff( year, DOB, getdate())
order by Net_Revenue desc;

--Q11--END
--Q12--BEGIN 

select top(1)
prod_cat as [Product Category],
SUM(case when total_amt<0 then total_amt else 0 END)*(-1) as [Return Amount]
From
[prod_cat_info] T1
left join [Transactions] T2 on T1.prod_cat_code = T2.prod_cat_code AND prod_sub_cat_code = prod_subcat_code
where
tran_date > dateadd( month,-3, (Select max (tran_date) From [Transactions]))
group by
prod_cat
order by [Return Amount] desc 

--Q12--END
--Q13--BEGIN 

select top(1)
store_type, sum(Qty) as Quantity, round(sum(total_amt),2) as Sales
from
[Transactions]
group by
Store_type
order by
Sales desc;

--Q13--END
--Q14--BEGIN 

select
prod_cat, avg(case when total_amt>0 then total_amt else 0 end) as Average_rev
from
[prod_cat_info] T1
left join [Transactions] T2 on T1.prod_cat_code = T2.prod_cat_code AND prod_sub_cat_code = prod_subcat_code
group by
prod_cat
having
avg(case when total_amt>0 then total_amt else 0 end)>(select avg(case when total_amt>0 then total_amt else 0 end) from [Transactions]);

--Q14--END
--Q15--BEGIN 

Select 
prod_subcat,avg(case when total_amt>0 then total_amt else 0 end) as Avg_revenue,sum(total_amt) as Total_revenue
from
[prod_cat_info] T1
left join [Transactions] T2 on T1.prod_cat_code = T2.prod_cat_code AND prod_sub_cat_code = prod_subcat_code
where
T2.prod_cat_code in
(select top(5)
prod_cat_code
from
[Transactions]
group by
prod_cat_code
order by
sum (Qty) desc)
group by
prod_subcat;

--Q15--END