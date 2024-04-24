class ChangeIndexOnChat < ActiveRecord::Migration[7.1]
  def change
    remove_index :chats, name: "index_chats_on_number_and_application_id"
    add_index :chats, [:application_id, :number], unique: true
  end
end
