class CreateOpeningHours < ActiveRecord::Migration[7.2]
  def change
    create_table :opening_hours do |t|
      t.integer :day_of_week,       null: false
      t.time :opening_time
      t.time :closing_time
      t.boolean :closed,            default: false
      t.references :establishment,  null: false, foreign_key: true

      t.timestamps
    end
  end
end
