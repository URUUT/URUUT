class CreateSponsor < ActiveRecord::Migration
  def change
    create_table :sponsors do |t|
      t.string :payment_type
      t.string :name
      t.string :card_number
      t.date :card_expiration
      t.string :cvc
      t.string :email
      t.string :phone
    end
  end
end
