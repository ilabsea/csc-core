require 'rails_helper'

module CscCore
  RSpec.describe User, type: :model do
    it { is_expected.to define_enum_for(:role).with_values(system_admin: 1, program_admin: 2, staff: 3, lngo: 4) }

    describe "#display_name" do
      let!(:user) { build(:user, email: "care.nara@program.org") }

      it { expect(user.display_name).to eq("CARE.NARA") }
    end

    describe "validate presence of program_id" do
      context "is system_admin" do
        before { allow(subject).to receive(:system_admin?).and_return(true) }
        it { is_expected.not_to validate_presence_of(:program_id) }
      end

      context "is not system_admin" do
        before { allow(subject).to receive(:system_admin?).and_return(false) }
        it { is_expected.to validate_presence_of(:program_id) }
      end
    end

    describe "validate presence of local_ngo_id" do
      context "is lngo" do
        before { allow(subject).to receive(:lngo?).and_return(true) }
        it { is_expected.to validate_presence_of(:local_ngo_id) }
      end

      context "is not lngo" do
        before { allow(subject).to receive(:lngo?).and_return(false) }
        it { is_expected.not_to validate_presence_of(:local_ngo_id) }
      end
    end

    describe "#regenerate_authentication_token!" do
      let!(:user) { create(:user) }

      context "token is expired" do
        before {
          user.update(authentication_token: "a1b2c3d4", token_expired_date: DateTime.yesterday)
          user.regenerate_authentication_token!
        }

        it { expect(user.reload.authentication_token).not_to eq("a1b2c3d4") }
      end

      context "token is not expired" do
        before {
          user.update(authentication_token: "a1b2c3d4", token_expired_date: DateTime.tomorrow)
          user.regenerate_authentication_token!
        }

        it { expect(user.reload.authentication_token).to eq("a1b2c3d4") }
      end
    end
  end
end
