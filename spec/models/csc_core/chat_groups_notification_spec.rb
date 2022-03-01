# frozen_string_literal: true

# == Schema Information
#
# Table name: chat_groups_notifications
#
#  id              :bigint           not null, primary key
#  chat_group_id   :integer
#  notification_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require "rails_helper"

module CscCore
  RSpec.describe ChatGroupsNotification, type: :model do
    it { is_expected.to belong_to(:notification) }
    it { is_expected.to belong_to(:chat_group) }
  end
end
