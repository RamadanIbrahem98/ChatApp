class CreateChats < ActiveRecord::Migration[7.1]
  def change
    create_table :chats do |t|
      t.integer :number, null: false
      t.references :application, null: false, foreign_key: true
      t.integer :messages_count, null: false, default: 0
      t.index [:number, :application_id], unique: true

      t.timestamps
    end
  end
end
