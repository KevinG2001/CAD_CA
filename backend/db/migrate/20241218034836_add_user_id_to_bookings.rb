class AddUserIdToBookings < ActiveRecord::Migration[8.0]
  def change
    add_column :bookings, :user_id, :integer
  end
end
