class CreateRooms < ActiveRecord::Migration[8.0]
  def change
    create_table :rooms do |t|
      t.string :name
      t.decimal :price_per_night
      t.boolean :booked

      t.timestamps
    end
  end
end
