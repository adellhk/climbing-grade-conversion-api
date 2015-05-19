class CreateConversions < ActiveRecord::Migration
  def change
    create_table :conversions do |t|

      t.timestamps null: false
    end
  end
end
