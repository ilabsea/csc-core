# frozen_string_literal: true

class CreateCscCoreMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :messages do |t|
      t.text    :content
      t.string  :milestone
      t.integer :program_id
      t.boolean :actived, default: true

      t.timestamps
    end
  end
end
