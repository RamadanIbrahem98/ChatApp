class RemoveFullTextIndexFromMessages < ActiveRecord::Migration[7.1]
  def change
    remove_index :messages, name: "index_messages_on_body"
  end
end
