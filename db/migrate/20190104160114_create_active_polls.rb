class CreateActivePolls < ActiveRecord::Migration[4.2]
  def change
    create_table :active_polls do |t|
      t.datetime   :created_at, null: false
      t.datetime   :updated_at, null: false
    end
  end
end
