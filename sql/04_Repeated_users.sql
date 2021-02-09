with 
	cust as (select distinct customer_id, customer_unique_id from customer),
	items_prod as (select a.*,b.product_weight_g from items as a LEFT JOIN products as b on a.product_id = b.product_id)
 
SELECT 

:given_date as Date_given,

-- from customer table ONLY
b.customer_unique_id,
count(distinct a.customer_id) as count_customer_id,

--from orders table ONLY
 

SUM(CASE WHEN
		(order_status = 'delivered'		AND :given_date	>= order_purchase_timestamp)
	 OR (order_status = 'invoiced' 		AND :given_date	>= order_purchase_timestamp)	
	 OR (order_status = 'shipped' 		AND :given_date	>= order_purchase_timestamp)	
	 OR (order_status = 'processing'	AND :given_date	>= order_purchase_timestamp)	
	 OR (order_status = 'unavailable'	AND :given_date	>= order_purchase_timestamp)			
	 OR (order_status = 'canceled'		AND :given_date	>= order_purchase_timestamp)				
	 OR (order_status = 'created'		AND :given_date	>= order_purchase_timestamp)		
	 OR (order_status = 'approved'		AND :given_date	>= order_purchase_timestamp)			THEN  1 ELSE 0 END) as total_orders,
--from items + orders
SUM(CASE WHEN 
		(order_status = 'delivered' AND :given_date	>= order_delivered_customer_date)
	 OR (order_status = 'invoiced'	AND :given_date	<= shipping_limit_date)				THEN  price ELSE 0 END) as gained_price
 
FROM 
	orders as a
	
	LEFT JOIN 
		cust as b 
		on a.customer_id = b.customer_id
	LEFT JOIN 
		items_prod as c 
		on a.order_id = c.order_id
 
GROUP BY
	customer_unique_id 
having 
	SUM(CASE WHEN
		(order_status = 'delivered'		AND :given_date	>= order_purchase_timestamp)
	 OR (order_status = 'invoiced' 		AND :given_date	>= order_purchase_timestamp)	
	 OR (order_status = 'shipped' 		AND :given_date	>= order_purchase_timestamp)	
	 OR (order_status = 'processing'	AND :given_date	>= order_purchase_timestamp)	
	 OR (order_status = 'unavailable'	AND :given_date	>= order_purchase_timestamp)			
	 OR (order_status = 'canceled'		AND :given_date	>= order_purchase_timestamp)				
	 OR (order_status = 'created'		AND :given_date	>= order_purchase_timestamp)		
	 OR (order_status = 'approved'		AND :given_date	>= order_purchase_timestamp)			THEN  1 ELSE 0 END)
	 > 0

order BY
	gained_price desc