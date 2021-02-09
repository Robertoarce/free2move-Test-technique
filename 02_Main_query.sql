with 
	cust as (select distinct customer_id, customer_unique_id from customer),
	items_prod as (select a.*,b.product_weight_g from items as a LEFT JOIN products as b on a.product_id = b.product_id)
 
SELECT 

:given_date as Date_given,

-- from customer table ONLY
b.customer_unique_id,
count(distinct a.customer_id) as count_customer_id,

--from orders table ONLY
SUM(CASE WHEN order_status = 'delivered' 	AND :given_date	>= order_delivered_customer_date 	THEN  1 ELSE 0 END) as delivered,
SUM(CASE WHEN order_status = 'invoiced' 	AND :given_date	>= order_delivered_customer_date 	THEN  1 ELSE 0 END) as invoiced,
SUM(CASE WHEN order_status = 'shipped' 		AND :given_date	>= order_delivered_carrier_date 	THEN  1 ELSE 0 END) as shipped,
SUM(CASE WHEN order_status = 'processing'	AND :given_date	>= order_approved_at 				THEN  1 ELSE 0 END) as processing,
SUM(CASE WHEN order_status = 'unavailable'	AND :given_date	>= order_approved_at 				THEN  1 ELSE 0 END) as unavailable,
SUM(CASE WHEN order_status = 'canceled'		AND :given_date	>= order_approved_at 				THEN  1 ELSE 0 END) as canceled,
SUM(CASE WHEN order_status = 'created'		AND :given_date	>= order_purchase_timestamp 		THEN  1 ELSE 0 END) as created,
SUM(CASE WHEN order_status = 'approved'		AND :given_date	>= order_approved_at 				THEN  1 ELSE 0 END) as approved,

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
	 OR (order_status = 'invoiced'	AND :given_date	<= shipping_limit_date)				THEN  price ELSE 0 END) as gained_price,

SUM(CASE WHEN order_status = 'canceled'		AND :given_date	>= order_approved_at 				THEN  price ELSE 0 END) as lost_price,
SUM(CASE WHEN (
				(order_status 	 = 'shipped'	 AND :given_date	>= order_delivered_carrier_date)	--shipped
				OR (order_status = 'processing'	 AND :given_date	>= order_approved_at)				--processing
				OR (order_status = 'unavailable' AND :given_date	>= order_approved_at)				--unavailable
				OR (order_status = 'created' 	 AND :given_date	>= order_purchase_timestamp)		--created
				OR (order_status = 'approved' 	 AND :given_date	>= order_approved_at)				--approved
	 			)																				THEN  price ELSE 0 END) as opportunity_price,

-- same but for freight_cost
SUM(CASE WHEN (
				   (order_status = 'delivered' 	 AND :given_date	>= order_delivered_customer_date)	--delivered
				OR (order_status = 'invoiced' 	 AND :given_date	>= order_approved_at)	            --invoiced
				--OR (order_status = 'canceled'	 AND :given_date	>= order_approved_at)				-- Cancel does not get freight costs
				OR (order_status = 'shipped' 	 AND :given_date	>= order_delivered_carrier_date)	--shipped
				OR (order_status = 'processing'	 AND :given_date	>= order_approved_at)				--processing
				OR (order_status = 'unavailable' AND :given_date	>= order_approved_at)				--unavailable
				OR (order_status = 'created' 	 AND :given_date	>= order_purchase_timestamp)		--created
				OR (order_status = 'approved' 	 AND :given_date	>= order_approved_at)				--approved
	 			)																				THEN  freight_value ELSE 0 END) as freight_cost,
 
-- from items + product
SUM(product_weight_g) as total_prod_weight	
 
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

order BY
	gained_price desc;