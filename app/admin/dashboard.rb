# frozen_string_literal: true
ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    # div class: "blank_slate_container", id: "dashboard_default_message" do
    #   span class: "blank_slate" do
    #     span I18n.t("active_admin.dashboard_welcome.welcome")
    #     small I18n.t("active_admin.dashboard_welcome.call_to_action")
    #   end
    # end
    section do
      columns do
        column do
          panel 'Unapproved orders' do
            columns class: 'mb-0' do
              column span: 2, class: 'summary' do
                label '1 orders', class: 'quantity-items-summary'
              end
              column do
                i class: 'fa-solid fa-cart-circle-exclamation'
              end
            end
          end
        end
        column do
          panel "Current month's revenue" do

          end
        end
        column do
          panel 'Customers' do

          end
        end
        column do
          panel 'Products' do

          end
        end
      end
    end

    section do
      columns do
        column do
          panel 'Report' do
            render 'layouts/partials/column_chart'
          end
        end
        column do
          
        end
      end
    end
    # Here is an example of a simple dashboard with columns and panels.
    #
    # columns do
    #   column do
    #     panel "Recent Posts" do
    #       ul do
    #         Post.recent(5).map do |post|
    #           li link_to(post.title, admin_post_path(post))
    #         end
    #       end
    #     end
    #   end

    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end
  end # content
end
