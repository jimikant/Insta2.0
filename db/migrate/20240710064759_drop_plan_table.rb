class DropPlanTable < ActiveRecord::Migration[7.1]
  def up
    drop_table :plans
  end

  def down
    create_table :payments do |t|
      t.string :name
      t.text :description
      t.string :stripe_plan_id
      t.integer :amount
      t.string :interval
      t.timestamps
    end
  end
end
