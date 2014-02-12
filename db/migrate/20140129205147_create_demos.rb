class CreateDemos < ActiveRecord::Migration
  def change
    create_table :demos do |t|
      t.string :first_name
      t.string :last_name
      t.string :organization
      t.string :email
      t.string :phone
      t.date :founded_date
      t.integer :non_profit
      t.text :organization_description
      t.integer :money_raised_yearly
      t.boolean :fund_events
      t.boolean :fund_website_donation
      t.boolean :fund_direct_email
      t.boolean :fund_email
      t.boolean :fund_year_round
      t.boolean :fund_seasonal
      t.boolean :fund_other
      t.string :fund_other_description
      t.integer :type_of_accepted_donations
      t.boolean :accepts_donations_from_individual
      t.boolean :accepts_donations_from_businesses
      t.boolean :accepts_donations_from_foundations
      t.boolean :accepts_donations_from_other
      t.string :accepts_donations_from_other_description
      t.integer :sponsorship_program
      t.integer :crowdfunding
      t.integer :crowdfunding_campaign_goals
      t.integer :seven_days_to_receive_funds
      t.string :social_outreach

      t.timestamps
    end
  end
end
