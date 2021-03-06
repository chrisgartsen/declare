class CreateExpenseTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :expense_types do |t|
      t.string :name, null: false
      t.timestamps
    end

    add_index :expense_types, :name, unique: true

  end
end
