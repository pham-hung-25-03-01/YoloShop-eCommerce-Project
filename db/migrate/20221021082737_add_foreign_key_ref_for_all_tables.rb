class AddForeignKeyRefForAllTables < ActiveRecord::Migration[7.0]
  def change
    # product_images table
    execute 'ALTER TABLE product_images ADD FOREIGN KEY (product_id) REFERENCES products (id);'

    # products table
    execute 'ALTER TABLE products ADD FOREIGN KEY (event_id) REFERENCES events (id);'
    execute 'ALTER TABLE products ADD FOREIGN KEY (supplier_id) REFERENCES suppliers (id);'
    execute 'ALTER TABLE products ADD FOREIGN KEY (product_group_id) REFERENCES product_groups (id);'
    execute 'ALTER TABLE products ADD FOREIGN KEY (category_id) REFERENCES categories (id);'
    execute 'ALTER TABLE products ADD FOREIGN KEY (age_id) REFERENCES ages (id);'

    # product_price_logs table
    execute 'ALTER TABLE product_price_logs ADD FOREIGN KEY (admin_id) REFERENCES admins (id);'
    execute 'ALTER TABLE product_price_logs ADD FOREIGN KEY (product_id) REFERENCES products (id);'

    # role_details table
    execute 'ALTER TABLE role_details ADD FOREIGN KEY (permission_id) REFERENCES permissions (id);'
    execute 'ALTER TABLE role_details ADD FOREIGN KEY (role_id) REFERENCES roles (id);'

    # comments table
    execute 'ALTER TABLE comments ADD FOREIGN KEY (product_id) REFERENCES products (id);'
    execute 'ALTER TABLE comments ADD FOREIGN KEY (user_id) REFERENCES users (id);'

    # banners table
    execute 'ALTER TABLE banners ADD FOREIGN KEY (event_id) REFERENCES events (id);'
    execute 'ALTER TABLE banners ADD FOREIGN KEY (admin_id) REFERENCES admins (id);'

    # admins table
    execute 'ALTER TABLE admins ADD FOREIGN KEY (role_id) REFERENCES roles (id);'

    # reviews table
    execute 'ALTER TABLE reviews ADD FOREIGN KEY (product_id) REFERENCES products (id);'
    execute 'ALTER TABLE reviews ADD FOREIGN KEY (user_id) REFERENCES users (id);'

    # inventories table
    execute 'ALTER TABLE inventories ADD FOREIGN KEY (product_id) REFERENCES products (id);'

    # inventory_quantity_logs table
    execute 'ALTER TABLE inventory_quantity_logs ADD FOREIGN KEY (inventory_id) REFERENCES inventories (id);'
    execute 'ALTER TABLE inventory_quantity_logs ADD FOREIGN KEY (admin_id) REFERENCES admins (id);'

    # orders table
    execute 'ALTER TABLE orders ADD FOREIGN KEY (user_id) REFERENCES users (id);'
    execute 'ALTER TABLE orders ADD FOREIGN KEY (coupon_id) REFERENCES coupons (id);'

    # order_details table
    execute 'ALTER TABLE order_details ADD FOREIGN KEY (inventory_id) REFERENCES inventories (id);'
    execute 'ALTER TABLE order_details ADD FOREIGN KEY (order_id) REFERENCES orders (id);'

    # invoices table
    execute 'ALTER TABLE invoices ADD FOREIGN KEY (order_id) REFERENCES orders (id);'
    execute 'ALTER TABLE invoices ADD FOREIGN KEY (admin_id) REFERENCES admins (id);'
    execute 'ALTER TABLE invoices ADD FOREIGN KEY (payment_id) REFERENCES payments (id);'
  end
end
