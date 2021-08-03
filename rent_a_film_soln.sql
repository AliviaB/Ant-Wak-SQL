--1. We want to run an Email Campaigns for customers of Store 2 (First, Last name,and Email address of customers from Store 2)
select first_name,last_name,email from customer where store_id=2;

--2. List of the movies with a rental rate of 0.99$
 select film_id,title from film where rental_rate=0.99;
 
--3. Your objective is to show the rental rate and how many movies are in each rental rate categories 
select rental_rate,count(1) from film
group by rental_rate;

--4. Which rating do we have the most films in?
select rating,count(1) cnt from film
group by rating order by cnt desc limit 1;
 --ANS:PG-13
  
 --5. Which rating is most prevalent in each store?
 select count(1) cnt,rating,store_id from film f 
inner join inventory i on f.film_id =i.film_id 
group by rating,store_id
order by cnt desc limit 5;
--6. We want to mail the customers about the upcoming promotion
select email from customer;
--7. List of films by Film Name, Category, Language
select title film_name,c.name category,l.name language
from film f inner join film_category fc 
on f.film_id=fc.film_id
inner join category c 
on c.category_id=fc.category_id
inner join language l
on l.language_id=f.language_id
order by film_name,category,language
--8. How many times each movie has been rented out?
select count(rental_id) times_rented,title
from film f 
inner join inventory i
on f.film_id=i.film_id
inner join rental r
on r.inventory_id=i.inventory_id
group by title
--9. What is the Revenue per Movie?
select sum(p.amount) revenue,title
from film f 
inner join inventory i
on f.film_id=i.film_id
inner join rental r
on r.inventory_id=i.inventory_id
inner join payment p 
on p.rental_id=r.rental_id
group by title
--10.Most Spending Customer so that we can send him/her rewards or debate points

select c.first_name,c.last_name,sum(amount) spent
from customer c
inner join payment p
on p.customer_id=c.customer_id
group by c.first_name,c.last_name
order by spent desc limit 1

--11. What Store has historically brought the most revenue?
select sum(amount) rev,store_id
from payment p
inner join rental r 
on r.rental_id=p.rental_id
inner join inventory i
on r.inventory_id=i.inventory_id
group by store_id
order by rev desc
--12.How many rentals do we have for each month?
select count(rental_id),monthname(rental_date) month,year(rental_date) 
from rental
group by monthname(rental_date),year(rental_date)
--13.Rentals per Month (such Jan => How much, etc)
select sum(amount)rev,monthname(rental_date) month,year(rental_date) 
from rental r
inner join payment p
on p.rental_id=r.rental_id
group by monthname(rental_date),year(rental_date)
--14.Which date the first movie was rented out?
select min(rental_date) first_rent from rental
--15.Which date the last movie was rented out?
select max(rental_date) last_rent from rental
--For each movie, when was the first time and last time it was rented out?
select min(rental_date)first_rent,max(rental_date) last_rent,title
from film f 
inner join inventory i
on f.film_id=i.film_id
inner join rental r
on r.inventory_id=i.inventory_id
group by title
--17.What is the Last Rental Date of every customer?
select max(rental_date) last_rent,first_name,last_name
from   rental r
inner join payment p
on p.rental_id=r.rental_id
inner join customer c
on p.customer_id=c.customer_id
group by last_name,first_name
--18.What is our Revenue Per Month?
select sum(amount) rev,monthname(rental_date),year(rental_date)
from payment p
inner join rental r 
on r.rental_id=p.rental_id
group by monthname(rental_date),year(rental_date)
--19.How many distinct Renters do we have per month?
select count(distinct customer_id)dis_renter,monthname(rental_date),year(rental_date)
from  rental r 
group by monthname(rental_date),year(rental_date)
--20.Show the Number of Distinct Film Rented Each Month
select count(distinct film_id)dis_film,monthname(rental_date),year(rental_date)
from  rental r 
inner join inventory i
on r.inventory_id=i.inventory_id
group by monthname(rental_date),year(rental_date)
--21.Number of Rentals in Comedy, Sports, and Family
SELECT
c.name AS category
, count(r.rental_id) AS total_rental
FROM  rental AS r 
INNER JOIN inventory AS i ON r.inventory_id = i.inventory_id
INNER JOIN film AS f ON i.film_id = f.film_id
INNER JOIN film_category AS fc ON f.film_id = fc.film_id
INNER JOIN category AS c ON fc.category_id = c.category_id
where c.name in ('Comedy', 'Sports','Family')
GROUP BY c.name
ORDER BY total_rental DESC;
--22.Users who have been rented at least 3 times
SELECT p.customer_id,first_name,last_name
    FROM payment AS p
    inner join customer c 
    on c.customer_id=p.customer_id
    GROUP BY p.customer_id
    HAVING  COUNT(p.customer_id) >= 3;
--23.How much revenue has one single store made over PG13 and R-rated films?
select sum(amount)revenue,store_id
from payment p
inner join rental r 
on r.rental_id=p.rental_id
inner join inventory i
on i.inventory_id=r.inventory_id
inner join film f
where f.rating in ('PG-13','R')
group by store_id
--24.Active User where active = 1
select * from customer where active=1

--25.Reward Users: who has rented at least 30 times
SELECT p.customer_id,first_name,last_name
    FROM payment AS p
    inner join customer c 
    on c.customer_id=p.customer_id
    GROUP BY p.customer_id
    HAVING  COUNT(p.customer_id) >= 30;
--26.Reward Users who are also active
SELECT p.customer_id,first_name,last_name
    FROM payment AS p
    inner join customer c 
    on c.customer_id=p.customer_id
    where active=1
    GROUP BY p.customer_id
    HAVING  COUNT(p.customer_id) >= 30;
--27.All Rewards Users with Phone

SELECT p.customer_id,first_name,last_name
    FROM payment AS p
    inner join customer c 
    on c.customer_id=p.customer_id
    inner join address a
	on c.address_id=a.address_id
	where a.phone is not null
    GROUP BY p.customer_id
    HAVING  COUNT(p.customer_id) >= 30;