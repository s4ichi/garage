require "spec_helper"

describe Garage::ControllerHelper do
  let(:controller) do
    controller = Object.new
    controller.extend described_class
    controller
  end

  describe "#extract_datetime_query" do
    before do
      allow(controller).to receive_messages(:params => params)
    end

    let(:params) do
      {}
    end

    context "without corresponding key" do
      it "returns nil" do
        expect(controller.send(:extract_datetime_query, "created")).to eq(nil)
      end
    end

    context "with corresponding key" do
      let(:params) do
        {
          "created.lte" => 0,
          "created.gte" => 0,
          "updated.lte" => 0,
          "updated.gte" => 0,
        }
      end

      it "returns query Hash with matched operator => time" do
        expect(controller.send(:extract_datetime_query, "created")).to eq({
          :lte => Time.zone.at(0),
          :gte => Time.zone.at(0),
        })
      end
    end
  end

  describe "#requested_by?" do
    before do
      allow(controller).to receive_messages(current_resource_owner: current_resource_owner)
    end

    let(:user) do
      double(id: 1)
    end

    let(:current_resource_owner) do
      double(id: 1)
    end

    context "without current resource owner" do
      let(:current_resource_owner) do
        nil
      end

      it "returns false" do
        expect(controller).not_to be_requested_by user
      end
    end

    context "with different users" do
      let(:current_resource_owner) do
        double(id: 2)
      end

      it "returns false" do
        expect(controller).not_to be_requested_by user
      end
    end

    context "with different classes" do
      before do
        allow(current_resource_owner).to receive_messages(class: Class.new)
      end

      it "returns false" do
        expect(controller).not_to be_requested_by user
      end
    end

    context "with same user" do
      it "returns true" do
        expect(controller).to be_requested_by user
      end
    end
  end
end
