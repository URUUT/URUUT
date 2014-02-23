ActiveAdmin.register Project do
  index do
    column :project_title do |project|
      link_to project.project_title, admin_project_path(project)
    end

    default_actions
  end

  form do |f|
    f.inputs "Project Details" do
      f.input :category, :as => :select, :collection => project_categories, prompt: 'Select a Category'
      f.input :description
      f.input :duration
      f.input :goal
      f.input :address
      f.input :project_title
      f.input :sponsorship_permission

      f.input :city
      f.input :state, :as => :select, :collection => us_states, prompt: 'Choose a state'
      f.input :zip
      f.input :neighborhood
      f.input :title
      f.input :live
      f.input :short_description
      f.input :perk_permission

      f.input :status
      f.input :organization
      f.input :website
      f.input :twitter_handle
      f.input :facebook_page
      f.input :seed_video

      f.input :story
      f.input :about
      f.input :large_image
      f.input :seed_image
      f.input :cultivation_image
      f.input :ready_for_approval
      f.input :organization_type, :as => :select, :collection => project_org_type, prompt: 'Select a Type'
      f.input :cultivation_mime_type

      f.input :organization_classification, :as => :select, :collection => project_org_class, prompt: 'Select a Classification'
      f.input :cultivation_video
      f.input :campaign_deadline
      f.input :sponsor_permission
      f.input :step
      f.input :seed_mime_type
      f.input :partial_funding
    end
    f.actions
  end
end
