class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :subject
      t.text :body
      t.integer :user_id

      t.timestamps
    end
  end
end
