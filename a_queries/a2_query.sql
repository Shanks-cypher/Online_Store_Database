USE online_store;

-- B. SIMULATE NEW ORDER ITEM (This runs the trigger)
INSERT INTO order_items (order_id, product_id, quantity, subtotal)
VALUES (1, 1, 2, 130000.00);