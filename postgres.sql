#1 Retrieve Internet Sales Amount As Per Customer. In other words, we can say show the Detail of amount spent by customers during purchase from Internet.
select concat(c.firstname,' ',c.lastname) as "Name", sum(f.salesamount::numeric) as "Spent Internet" 
from factinternetsales f
    inner join dimcustomer c using(customerkey)
group by 1
order by 1;

#2 View Internet Sales amount detail between year 2005 to 2008
select f.salesamount, d.calendaryear 
from factinternetsales f
    inner join dimdate d on (f.duedatekey=d.datekey)
where d.calendaryear between 2005 and 2008
order by d.calendaryear;

select sum(f.salesamount::numeric), d.calendaryear 
from factinternetsales f
    inner join dimdate d on (f.duedatekey=d.datekey)
where d.calendaryear between 2005 and 2008
group by 2
order by 2;

#3 View Internet Sales by product category and sub-category.
select englishproductcategoryname, englishproductsubcategoryname , sum(f.salesamount::numeric) 
from factinternetsales f
    inner join dimproduct dp using (productkey)
    inner join dimproductsubcategory dpsc using(productsubcategorykey)
    inner join dimproductcategory using (productcategorykey)
group by 1,2

#4 View Internet Sales and Freight Cost by product category, sub-category and product.
select sum(f.salesamount::numeric) as "Internet Sales", 
    sum(freight::numeric) as "Freight Cost", 
    englishproductcategoryname, 
    englishproductsubcategoryname, 
    englishproductname  
from factinternetsales f
    inner join dimproduct dp using (productkey)
    inner join dimproductsubcategory dpsc using(productsubcategorykey)
    inner join dimproductcategory using (productcategorykey)
group by 3,4,5;

#5 Retrieve only those products whose names begin with “A” and Internet sales amount <5000
select sum(f.salesamount::numeric) as "Internet Sales", 
    englishproductname as "Product" 
from factinternetsales f
    inner join dimproduct dp using (productkey)
where dp.englishproductname like 'A%'
group by 2
having (sum(salesamount)::numeric)<5000;

#6 What is sales amount in all the countries??
select salesterritorycountry, sum(f.salesamount::numeric) as "Internet Sales" 
from factinternetsales f
    inner join dimsalesterritory using (salesterritorykey)
group by 1

#7 Retrieve all the products in descending order of their Internet sales amount of year 2007 
select englishproductname as "Product", sum(f.salesamount::numeric) as "InternetSales", d.calendaryear 
from factinternetsales f
    inner join dimproduct dp using (productkey)
    inner join dimdate d on (f.duedatekey=d.datekey)
where d.calendaryear=2007
group by 1,3
order by 2 desc;


#8 Generate a report with Internet Sales sub total, grand total per year and month.
select d.calendaryear, d.monthnumberofyear,
    sum(f.salesamount::numeric) as amount
from factinternetsales f
    inner join dimdate d on (f.orderdatekey=d.datekey)
group by rollup (calendaryear, monthnumberofyear)

#9 Generate a report with the amount of "Pedals" and "Tires and Tubes" category of products 
#in the inventory. Also with the amount of in and outs of each of them on the second half of the year 2006.
select englishproductname, count(productkey), sum(unitsin), sum(unitsout) 
from factproductinventory
    inner join dimproduct dp using (productkey)
    inner join dimdate using(datekey)
    inner join dimproductsubcategory using(productsubcategorykey)
    inner join dimproductcategory using (productcategorykey)
where englishproductsubcategoryname in  ('Pedals', 'Tires and Tubes') 
and fiscalyear = 2006 and fiscalsemester =2
group by 1;

#10 Generate a report with the amount of calls, automatic responses and issues raised by 
#the call center operators. On working days during the morning shift, from the 20th working
#week until the end of the year 2007.

select count(calls) as "calls", count(automaticresponses) as "Automatic responses", count(issuesraised) as "Issues raised" 
    from factcallcenter inner join dimdate using(datekey)
where englishdaynameofweek not in('Saturday','Sunday') 
    and shift like '%AM%'
    and weeknumberofyear >= 20
    and fiscalyear = 2007