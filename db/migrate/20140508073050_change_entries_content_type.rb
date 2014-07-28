class ChangeEntriesContentType < ActiveRecord::Migration
  def change
    change_column :entries, :content, :text
  end
end
