ActiveAdmin.register Project do

	index do
	    column :name
	    column :amount do |p|
	    	number_to_currency p.amount
	    end
	    column :due_date
	    column :image_file_name do |img|
	    	if !img.image.url.nil?
	    		image_tag(img.image.url(:thumb))
	    	end
	    end
	  end

	# form do |f|

		
	# 	f.label :name 
	
	# 	f.text_field :name
	
	# 	f.label :amount
	
	# 	f.text_field :amount

	# 	f.label :due_date
	
	# 	f.text_field :due_date

	# 	f.label :image, "Select an image for the project"
	# 	f.file_field :image
	
	# 	f.submit "Sign up" 

	# end

	form do |f|
      f.inputs "Details" do
        f.input :name
        f.input :amount
      end
      f.inputs "Due Date" do
      	f.date_select :due_date, :label => "Due Date"
      end
      f.inputs "Assets" do
        f.input :image
      end
      f.buttons
    end

end
