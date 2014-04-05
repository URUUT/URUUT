ActiveAdmin.register Project do

  actions :all, :except => [:destroy]

  index do
    column :project_title do |project|
      link_to project.project_title, admin_project_path(project)
    end

    default_actions
  end

  show do |project|
    attributes_table do
      row :large_image do
        image_tag("#{project.large_image}/convert?w=500")
      end
      row :project_title
      row :organization
      row :organization_classification
      row :description
      row :duration do
        project.duration + " days"
      end

      row :goal do
        number_to_currency project.goal
      end
      row :partial_funding
      row :address
      row :city do
        project.city.capitalize
      end
      row :state
      row :zip
      row :category
      row :website
      row :twitter_handle
      row :facebook_page
      row :title
      row :short_description
      row :sponsorship_permission

      row :perk_permission

      row :status

      row :seed_video

      row :story
      row :about

      row :seed_image
      row :cultivation_image
      row :organization_type

      row :cultivation_video
      row :campaign_deadline
      row :sponsor_permission

      row :live
      row :hide_featured
    end
    active_admin_comments
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

      f.input :hide_featured, :label => "Hide Featured"
    end
    f.actions
  end

  action_item :only => :show do
    link_to('Approve Project', approve_project_admin_project_path(project), :method => :post) if project.ready_for_approval == 1
  end

  member_action :approve_project, :method => :post do
    # Just a regular controller method in here
    project = Project.find params[:id]
    project.approve!
    redirect_to :back, :notice => "Project Approved"
  end

  scope :unapproved do |projects|
    projects.where('ready_for_approval = ?', 1)
  end
end
