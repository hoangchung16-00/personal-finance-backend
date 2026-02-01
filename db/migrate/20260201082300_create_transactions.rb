class CreateTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :transactions do |t|
      t.references :account, null: false, foreign_key: true
      t.references :category, null: true, foreign_key: true
      t.decimal :amount, precision: 15, scale: 2, null: false
      t.integer :transaction_type, null: false, default: 1
      t.date :date, null: false
      t.text :description
      t.string :notes
      t.string :tags, array: true, default: []

      t.timestamps
    end

    add_index :transactions, :date
    add_index :transactions, :transaction_type
    add_index :transactions, [:account_id, :date]
  end
end
