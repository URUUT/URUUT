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
        panel "Projects Ready For Approval" do
          ul do
            Project.where(ready_for_approval: 1).each do |project|
              li link_to(project.title, admin_project_path(project))
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

    end
  end

end
