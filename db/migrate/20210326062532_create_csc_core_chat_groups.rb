# frozen_string_literal: true

class CreateCscCoreChatGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :chat_groups do |t|
      t.string   :title
      t.string   :chat_id
      t.boolean  :actived, default: true
      t.text     :reason
      t.string   :provider
      t.integer  :program_id
      t.string   :chat_type, default: "group"

      t.timestamps
    end
  end
end
