ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do
    div :class => "blank_slate_container", :id => "dashboard_default_message" do
      span :class => "blank_slate" do
        span I18n.t("active_admin.dashboard_welcome.welcome")
        small I18n.t("active_admin.dashboard_welcome.call_to_action")
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
  content do
    columns do
      column :class => 'projects-container' do
        unless Project.where(ready_for_approval: 1).count == 0
          panel "Projects Ready For Approval" do
            ul do
              Project.where(ready_for_approval: 1).each do |project|
                li link_to(project.title, admin_project_path(project))
              end
            end
          end
        end
      end

      column :class => 'projects-container' do
        panel "Recent Demo Requests (5)" do
          ul do
            Demo.limit(5).each do |demo|
              li link_to(demo.organization, admin_demo_path(demo))
            end
          end
        end
      end

      column :class => 'projects-container' do
        panel "Sign Ups" do
          h4 do
            text_node "Fee Plan ("
            text_node link_to Membership.includes(:plan).where(:plans => {:name => 'fee'}).count, admin_memberships_path(scope: 'fee')
            text_node ")"
          end
          h4 do
            text_node "Basic Plan ("
            text_node link_to Membership.joins(:plan).where(:plans => {:name => 'basic'}).count, admin_memberships_path(scope: 'basic')
            text_node ")"
          end
          h4 do
            text_node "Plus Plan ("
            text_node link_to Membership.joins(:plan).where(:plans => {:name => 'plus'}).count, admin_memberships_path(scope: 'plus')
            text_node ")"
          end
        end
      end
    end
  end

end
