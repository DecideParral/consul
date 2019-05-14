require "rails_helper"

describe Verification::Management::Document do

  let(:verification_document) { build(:verification_document, document_number: "12345678Z") }

  describe "validations" do

    it "is valid" do
      expect(verification_document).to be_valid
    end

    it "is not valid without a document number" do
      verification_document.document_number = nil
      expect(verification_document).not_to be_valid
    end

    it "is not valid without a document type" do
      verification_document.document_type = nil
      expect(verification_document).not_to be_valid
    end

    it "is valid without a date of birth" do
      verification_document.date_of_birth = nil
      expect(verification_document).to be_valid
    end

     it "is valid without a postal code" do
      verification_document.postal_code = nil
      expect(verification_document).to be_valid
    end

    describe "Allowed Age" do
      let(:min_age)                         { User.minimum_required_age }
      let(:over_minium_age_date_of_birth)   { Date.new((min_age + 10).years.ago.year, 12, 31) }
      let(:under_minium_age_date_of_birth)  { Date.new(min_age.years.ago.year, 12, 31) }
      let(:just_minium_age_date_of_birth)   { Date.new(min_age.years.ago.year, min_age.years.ago.month, min_age.years.ago.day) }

      describe "#valid_age?" do
        it "returns false when the user is younger than the user's minimum required age" do
          census_response = instance_double("CensusApi::Response", date_of_birth: under_minium_age_date_of_birth)
          expect(described_class.new.valid_age?(census_response)).to be false
        end

        it "returns true when the user has the user's minimum required age" do
          census_response = instance_double("CensusApi::Response", date_of_birth: just_minium_age_date_of_birth)
          expect(described_class.new.valid_age?(census_response)).to be true
        end

        it "returns true when the user is older than the user's minimum required age" do
          census_response = instance_double("CensusApi::Response", date_of_birth: over_minium_age_date_of_birth)
          expect(described_class.new.valid_age?(census_response)).to be true
        end
      end

      describe "#under_age?" do
        it "returns true when the user is younger than the user's minimum required age" do
          census_response = instance_double("CensusApi::Response", date_of_birth: under_minium_age_date_of_birth)
          expect(described_class.new.under_age?(census_response)).to be true
        end

        it "returns false when the user is user's minimum required age" do
          census_response = instance_double("CensusApi::Response", date_of_birth: just_minium_age_date_of_birth)
          expect(described_class.new.under_age?(census_response)).to be false
        end

        it "returns false when the user is older than user's minimum required age" do
          census_response = instance_double("CensusApi::Response", date_of_birth: over_minium_age_date_of_birth)
          expect(described_class.new.under_age?(census_response)).to be false
        end
      end
    end
  end
    end

    it "returns true when the user has the user's minimum required age" do
      census_response = instance_double("CensusApi::Response", date_of_birth: just_minium_age_date_of_birth)
      expect(described_class.new.valid_age?(census_response)).to be true
    end

    it "returns true when the user is older than the user's minimum required age" do
      census_response = instance_double("CensusApi::Response", date_of_birth: over_minium_age_date_of_birth)
      expect(described_class.new.valid_age?(census_response)).to be true
    end
  end

  describe "#under_age?" do
    it "returns true when the user is younger than the user's minimum required age" do
      census_response = instance_double("CensusApi::Response", date_of_birth: under_minium_age_date_of_birth)
      expect(described_class.new.under_age?(census_response)).to be true
    end

    it "returns false when the user is user's minimum required age" do
      census_response = instance_double("CensusApi::Response", date_of_birth: just_minium_age_date_of_birth)
      expect(described_class.new.under_age?(census_response)).to be false
    end

    it "returns false when the user is older than user's minimum required age" do
      census_response = instance_double("CensusApi::Response", date_of_birth: over_minium_age_date_of_birth)
      expect(described_class.new.under_age?(census_response)).to be false
    end
  end
end
