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
  
end
