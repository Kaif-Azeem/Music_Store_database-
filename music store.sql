create database music_shop

use music_shop

select * from album


Q1 who is the senior most employee based on job title??

select * from employee
order by levels desc
limit 1

Q2 Which country have the most invoices??

select *from invoice

select billing_country as a ,count(billing_country) 
 from invoice
group by billing_country 
order by a desc

SELECT billing_country AS a, COUNT(*) 
FROM invoice
GROUP BY billing_country 
ORDER BY COUNT(*) DESC;

Q3 what are top 3 values of total invoice 

select * from invoice

select total , billing_country
from invoice 
order by total desc 
limit 3

Q4 which city has the best customers? we would like to throw a promotonal music fastival in the city we made the most money . write a query that returns one city that has the 
highest sum of incoice totals ??

select sum(total) as invoice_total ,billing_city as bc 
from invoice 
group by bc 
order by  invoice_total desc
limit 1


Q5 who is the best customer? The customer who has spent the most money will be declared the best customer. write a query that returens the person who has spent the most money.

select * from customer 
select * from invoice 

select customer.customer_id , customer.first_name , customer.last_name ,sum(invoice.total) as total 
from customer 
join invoice on  customer.customer_id = invoice.customer_id
group by customer.customer_id , customer.first_name , customer.last_name
order by total desc 


-- Q21 write query to return the email ,first name ,last name and genre of all rock music listeners. return your list orderd alphabetically by email stating with A 


select * from customer 
select *from invoice 
select *from invoice_line
select *from track
select * from genre

select distinct email , first_name , last_name 
from customer
join invoice on customer.customer_id = invoice.customer_id 
join invoice_line on invoice.invoice_id =invoice_line.invoice_id 
where track_id in (
				   select track_id from track 
                   join genre on track.genre_id = genre.genre_id 
                   where genre.name like "Rock"
                   )
order by email asc                   
                   
                   
-- Q22 lets invite the artist who have written the most rock in our data set . write a query that returns the artist name and total track count of the top 10 rock bands??

select * from album
select * from track 
select * from genre 
select * from artist


SELECT artist.artist_id, artist.name, COUNT(track.track_id) AS num_of_songs
FROM track
JOIN album ON album.album_id = track.album_id
JOIN artist ON artist.artist_id = album.artist_id
JOIN genre ON genre.genre_id = track.genre_id 
WHERE genre.name = 'Rock'
GROUP BY artist.artist_id, artist.name
ORDER BY num_of_songs DESC;


-- Q23 return all the names that have a song length longer than the average song length . return the name and milliseconds for each track. order by the song length with the 
-- longest songs listed first

select * from track 

select name , milliseconds
from track
where milliseconds > (select avg(milliseconds) from track)
order by milliseconds desc
limit 10

-- Q3 find how much amount spent by each coustomer on artists ? write a query to returne the costomer name , artist name and total spent 


select * from track 
select * from customer 
select * from artist 
select * from invoice_line 

with best_selling_artist as (
	 select artist.artist_id as artist_id , artist.name as artist_name , sum(invoice_line.unit_price * invoice_line.quantity) as total_sales
     from invoice_line
     join track on track.track_id = invoice_line.track_id
     join album on album.album_id = track.album_id 
     join artist on artist.artist_id = album.artist_id
     group by artist.artist_id , artist.name 
     order by total_sales desc)


select c.customer_id , c.first_name, c.last_name , bsa.artist_name, sum(il.unit_price*il.quantity) as amount_spent
from invoice i 
join customer c on c.customer_id = i.customer_id
join invoice_line il on il.invoice_id = i.invoice_id
join track t on t.track_id = il.track_id
join album alb on alb.album_id = t.album_id
JOIN best_selling_artist bsa ON bsa.artist_id = alb.artist_id 
group by c.customer_id , c.first_name, c.last_name , bsa.artist_name
order by amount_spent desc

-- Q32 we want to find out the most popular music genre for each country. we determine the most popular genre as the genre with the highest amount of purchases. write a query 
-- that returns each country along with the top genre. for countries where the maximum number of purchases is shared returen all genres. 

select  * from invoice_line

with popular_genre as 
(
  select count(invoice_line.quantity) as purchase, customer.country ,genre.name, genre.genre_id , 
  row_number() over(partition by customer.country order by count(invoice_line.quantity) desc) as rowno
  from invoice_line
  join invoice on invoice.invoice_id = invoice_line.invoice_id 
  join customer on customer.customer_id = invoice.customer_id 
  join track on track.track_id = invoice_line.track_id 
  join genre on genre.genre_id = track.genre_id 
  group by  customer.country , genre.name,genre.genre_id 
  order by  customer.country asc ,count(invoice_line.quantity) desc
  
  
  )
 
select * from popular_genre  where rowno <= 1



 -- Q33 write a query that determine the customer who spent most in the music for each  country . 
 -- write a query that returns the country along with the top customer and how much they spent.
 -- for cpuntry alnog with the top customer and how much they spent. for countries where the top amount spent is sharred , provideall customers who spent this amount  


select * from customer 
select * from invoice 

with 
    customer_with_country as  (
	select customer.customer_id ,customer.first_name , customer.last_name , billing_country ,sum(total) as total_spending
	from invoice 
    join customer on customer.customer_id= invoice.customer_id 
	group by customer.customer_id ,customer.first_name , customer.last_name , billing_country
	order by customer.customer_id , total_spending  desc
     ),
     
     
     country_max_spending as (
     select billing_country, max(total_spending) as kul_khrch
     from customer_with_country
     group by billing_country)
     
select cc.customer_id ,cc.first_name , cc.last_name , cc.billing_country,cc.total_spending 
from customer_with_country cc 
join country_max_spending  ms on cc.billing_country = ms.billing_country
where cc.total_spending = ms.kul_khrch
order by total_spending desc


