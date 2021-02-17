use sakila;

#LAB MORNING 2021-02-17
#In the previous lab we wrote a query to find first name, last name, and emails of all the customers who rented Action movies. 
#Convert the query into a simple stored procedure. Use the following query:

drop procedure if exists find_names;

delimiter //
create procedure find_names()
begin 
select first_name, last_name, email
from customer
join rental on customer.customer_id = rental.customer_id
join inventory on rental.inventory_id = inventory.inventory_id
join film on film.film_id = inventory.film_id
join film_category on film_category.film_id = film.film_id
join category on category.category_id = film_category.category_id
where category.name = "Action"
group by first_name, last_name, email;

end;
// delimiter ;

call find_names();

#Now keep working on the previous stored procedure to make it more dynamic. 
#Update the stored procedure in a such manner that it can take a string argument for the category name and 
#return the results for all customers that rented movie of that category/genre. For eg., it could be action, animation, children, classics, etc.

drop procedure if exists find_names;

delimiter //
create procedure find_names(in param1 varchar(20))
begin 
select first_name, last_name, email
from customer
join rental on customer.customer_id = rental.customer_id
join inventory on rental.inventory_id = inventory.inventory_id
join film on film.film_id = inventory.film_id
join film_category on film_category.film_id = film.film_id
join category on category.category_id = film_category.category_id
where category.name COLLATE utf8mb4_general_ci = param1
group by first_name, last_name, email;

end;
// delimiter ;

call find_names("Action");

#Write a query to check the number of movies released in each movie category. 
#Convert the query in to a stored procedure to filter only those categories that have movies released greater than a certain number. 
#Pass that number as an argument in the stored procedure.

drop procedure if exists films_per_cat;

delimiter //
create procedure films_per_cat(in param1 int)
begin
select f.category_id, c.name,count(f.film_id) as n_films from film_category as f
join category as c
using (category_id)
group by f.category_id,c.name
Having  n_films > param1;
end;
// delimiter ;

call films_per_cat(61);
