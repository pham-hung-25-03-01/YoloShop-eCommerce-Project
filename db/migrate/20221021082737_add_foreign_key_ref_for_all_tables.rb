class AddForeignKeyRefForAllTables < ActiveRecord::Migration[7.0]
  def change
    # product_images table
    execute 'ALTER TABLE product_images ADD FOREIGN KEY (product_id) REFERENCES products (product_id);'

    # products table
    execute 'ALTER TABLE products ADD FOREIGN KEY (event_id) REFERENCES events (event_id);'
    execute 'ALTER TABLE products ADD FOREIGN KEY (supplier_id) REFERENCES suppliers (supplier_id);'
    execute 'ALTER TABLE products ADD FOREIGN KEY (product_group_id) REFERENCES product_groups (product_group_id);'
    execute 'ALTER TABLE products ADD FOREIGN KEY (category_id) REFERENCES categories (category_id);'
    execute 'ALTER TABLE products ADD FOREIGN KEY (age_id) REFERENCES ages (age_id);'

    # product_price_logs table
    execute 'ALTER TABLE product_price_logs ADD FOREIGN KEY (admin_id) REFERENCES admins (admin_id);'
    execute 'ALTER TABLE product_price_logs ADD FOREIGN KEY (product_id) REFERENCES products (product_id);'

    # role_details table
    execute 'ALTER TABLE role_details ADD FOREIGN KEY (permission_id) REFERENCES permissions (permission_id);'
    execute 'ALTER TABLE role_details ADD FOREIGN KEY (role_id) REFERENCES roles (role_id);'

    # comments table
    execute 'ALTER TABLE comments ADD FOREIGN KEY (product_id) REFERENCES products (product_id);'
    execute 'ALTER TABLE comments ADD FOREIGN KEY (user_id) REFERENCES users (user_id);'

    # banners table
    execute 'ALTER TABLE banners ADD FOREIGN KEY (event_id) REFERENCES events (event_id);'
    execute 'ALTER TABLE banners ADD FOREIGN KEY (admin_id) REFERENCES admins (admin_id);'

    # admins table
    execute 'ALTER TABLE admins ADD FOREIGN KEY (role_id) REFERENCES roles (role_id);'

    # reviews table
    execute 'ALTER TABLE reviews ADD FOREIGN KEY (product_id) REFERENCES products (product_id);'
    execute 'ALTER TABLE reviews ADD FOREIGN KEY (user_id) REFERENCES users (user_id);'

    # inventories table
    execute 'ALTER TABLE inventories ADD FOREIGN KEY (product_id) REFERENCES products (product_id);'

    # inventory_quantity_logs table
    execute 'ALTER TABLE inventory_quantity_logs ADD FOREIGN KEY (inventory_id) REFERENCES inventories (inventory_id);'
    execute 'ALTER TABLE inventory_quantity_logs ADD FOREIGN KEY (admin_id) REFERENCES admins (admin_id);'

    # orders table
    execute 'ALTER TABLE orders ADD FOREIGN KEY (user_id) REFERENCES users (user_id);'
    execute 'ALTER TABLE orders ADD FOREIGN KEY (coupon_id) REFERENCES coupons (coupon_id);'

    # order_details table
    execute 'ALTER TABLE order_details ADD FOREIGN KEY (inventory_id) REFERENCES inventories (inventory_id);'
    execute 'ALTER TABLE order_details ADD FOREIGN KEY (order_id) REFERENCES orders (order_id);'

    # invoices table
    execute 'ALTER TABLE invoices ADD FOREIGN KEY (order_id) REFERENCES orders (order_id);'
    execute 'ALTER TABLE invoices ADD FOREIGN KEY (admin_id) REFERENCES admins (admin_id);'
    execute 'ALTER TABLE invoices ADD FOREIGN KEY (payment_id) REFERENCES payments (payment_id);'
  end
end
