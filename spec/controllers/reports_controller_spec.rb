require 'rails_helper'

RSpec.describe ReportsController, type: :controller do
  let(:report) {create(:report)}
  let(:report_1) {create(:report)}
  let(:receipt) {create(:receipt, report: report)}

  describe "#index" do
    it "renders a index template" do
      get :index
      expect(response).to render_template(:index)
    end
    it "assigns a new report instance" do
      get :index
      expect(assigns(:report)).to be_a_new(Report)
    end
    it "has a 200 status code" do
      expect(response.code).to eq("200")
    end

    it "assigns reports variable for all created reports" do
      report
      report_1
      get :index
      expect(assigns(:reports)).to eq([report_1, report])
    end

    # it "say what?" do
    #   xhr :get, :index, :format => 'js'
    #   expect(assigns(:report)).to render_template( :partial => '_report')
    # end

  end # end of index

  describe "#create" do
    context "with valid parameters" do
      def valid_request
        post :create, {report: {
                        title: "Valid Report Title",
                        description: "Valid Description"}
                      }
      end

      it "adds a report to the database" do
        expect { valid_request }.to change { Report.count }.by(1)
      end
      it "redirects to report show page" do
        valid_request
        expect(response).to redirect_to(reports_path)
      end
      it "sets a flash message" do
        valid_request
        expect(flash[:notice]).to be
      end      
      it "has a 302 status code for a good redirect" do
        valid_request
        expect(response.code).to eq("302")
      end

      # it { should render_template(:format => 'js', :partial => '_report.html.erb') }

      # it "renders a new template" do
      #   valid_request
      #   expect(subject).to render_template(:index)
      # end

    end  # end of create with valid params

    context "with invalid parameters" do
      def invalid_request
        post :create, {report: {
                        title: nil,
                        description: nil}
                      }
      end
      
      it "doesn't create a record in the database" do
        expect { invalid_request }.not_to change {Report.count}
      end
      it "redirects back" do
        invalid_request
        expect(response).to redirect_to(reports_path)
      end
      it "sets a flash alert message" do
        invalid_request
        expect(flash[:notice]).to be
      end
      it "has a 302 status code for a good redirect" do
        invalid_request
        expect(response.code).to eq("302")
      end
    end # end of create with invalid params

  end # end of create

  describe "#show" do

    it "assigns a report instance variable with passed id" do
      report = FactoryGirl.create(:report)
      get :show, id: report.id
      expect(assigns(:report)).to eq(report)
    end
    it "renders the show template" do
      report = FactoryGirl.create(:report)
      get :show, id: report.id
      expect(response).to render_template(:show)
    end
    it "has a 200 status code for a good get response" do
      expect(response.code).to eq("200")
    end    
    it "assigns a new receipt instance" do
      # receipt = FactoryGirl.create(:receipt)
      get :show, id: report.id,receipt_id: receipt.id
      expect(assigns(:receipt)).to be_a_new(Receipt)
    end
  end # end of show

  describe "#edit" do
    
    it "retrieves the report with passed id and stores it in instance var" do
      report = FactoryGirl.create(:report)
      get :edit, id: report.id
      expect(assigns(:report)).to eq(report)
    end
    
    it "renders the edit template" do
      get :edit, id: report.id
      expect(response).to render_template(:edit)
    end

  end # end of edit

  describe "#update" do
    context "with valid request" do
      before do
        patch :update, id: report.id, report: {title: "new title", description: "Woohoo"}
      end

      it "redirects to the report show page" do
        expect(response).to redirect_to(reports_path)
      end

      it "changes the title of the report if it's different" do
        expect(report.reload.title).to eq("new title")
      end

      it "changes the description of the report if it's different" do
        expect(report.reload.description).to eq("Woohoo")
      end

      it "sets a notice flash message" do
        expect(flash[:notice]).to be
      end
    end # end of update with valid params

    context "with invalid params" do
      before { patch :update, id: report.id, report: {title: "", description: ""} }

      it "renders the edit page" do
        expect(response).to redirect_to(reports_path)
      end

      it "title blank: doesn't change the database" do
        expect(report.reload.title).not_to eq("")
      end

      it "description blank: doesn't change the database" do
        expect(report.reload.description).not_to eq("")
      end

      it "sets an alert flash message" do
        expect(flash[:notice]).to be
      end
    end # end of update with INvalid params
  end # end of  update with valid params

  describe "#destroy" do

    context "Good delete request" do
      let!(:report) { create(:report) }

      it "deletes the report from the database" do
        expect { delete :destroy, id: report.id }.to change { Report.count }.by(-1)
      end
      it "redirect to the home page (root path)" do
        delete :destroy, id: report.id
        expect(response).to redirect_to(reports_path)
      end
      it "sets a flash message" do
        delete :destroy, id: report.id
        expect(flash[:notice]).to be
      end
      it "has a 200 status code for a good get response for delete" do
        expect(response.code).to eq("200")
      end
    end # end of destroy with valid params

    context "with invalid params" do

      it "deletes the report from the database" do
        expect { delete :destroy, id: report.id }.to_not change { Report.count }
      end
      it "redirect to the home page (root path)" do
        delete :destroy, id: report.id
        expect(response).to redirect_to(reports_path)
      end
      it "sets a flash message" do
        delete :destroy, id: report.id
        expect(flash[:notice]).to be
      end
      it "has a 200 status code for a good get response" do
        expect(response.code).to eq("200")
      end

    end # end of destroy with INvalid params

  end # end of destroy

end # rspec end

