class CreateCars < ActiveRecord::Migration
  def change
    create_table :cars do |t|
      t.string :model
      t.integer :year
      t.belongs_to :brand
      t.string :color
    end
  end
end
