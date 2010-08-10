require File.dirname(__FILE__) + '/spec_helper'
include DataCatalog

describe Report do

  before do
    setup_api
    clean_slate
    @john = User.create(
      :name    => "John M. Porter",
      :email   => "john.m.porter@email.com",
      :curator => true
    )
  end

  describe ".all" do
    before do
      @jane = User.create(
        :name    => "Jane M. Porter",
        :email   => "jane@email.com",
        :curator => true
      )
      DataCatalog.with_key(@jane.primary_api_key) do
        Report.create(:text => "Report 1 by Jane", :status => "new")
        Report.create(:text => "Report 2 by Jane", :status => "new")
      end
    end

    it "should return a set of all user's reports" do
      reports = Report.all(:user_id => @jane.id)
      reports.first.should be_an_instance_of(Report)
      [1, 2].each_with_index do |n, i|
        reports[i].text.should == "Report #{n} by Jane"
      end
    end
  end

  describe ".create" do
    it "should create a new report when valid params are passed in" do
      DataCatalog.with_key(@john.primary_api_key) do
        @report = Report.create(
          :text   => "Report 1 by John",
          :status => "new"
        )
      end
      @report.should be_an_instance_of(Report)
      refreshed_report = Report.get(@report.id)
      refreshed_report.text.should == "Report 1 by John"
      refreshed_report.status.should == "new"
      refreshed_report.user_id.should == @john.id
    end
  end

  describe ".destroy" do
    before do
      DataCatalog.with_key(@john.primary_api_key) do
        @report = Report.create(
          :text   => "Report 1 by John",
          :status => "new"
        )
      end
    end

    it "should destroy an existing report as an admin" do
      Report.destroy(@report.id).should be_true
    end

    it "should destroy an existing report as the user" do
      DataCatalog.with_key(@john.primary_api_key) do
        Report.destroy(@report.id).should be_true
      end
    end

    it "should raise NotFound when attempting to destroy non-existing report" do
      executing do
        Report.destroy(mangle(@report.id))
      end.should raise_error(NotFound)
    end
  end

  describe ".get" do
    before do
      DataCatalog.with_key(@john.primary_api_key) do
        @report = Report.create(
          :text   => "Report 1 by John",
          :status => "new"
        )
      end
    end

    it "should return a report" do
      report = Report.get(@report.id)
      report.should be_an_instance_of(Report)
      report.text.should == "Report 1 by John"
    end

    it "should raise NotFound if no report exists" do
      executing do
        Report.get(mangle(@report.id))
      end.should raise_error(NotFound)
    end
  end

  describe ".update" do
    before do
      DataCatalog.with_key(@john.primary_api_key) do
        @report = Report.create(
          :text   => "Report 1 by John",
          :status => "new"
        )
      end
    end

    it "should update an existing report with valid params" do
      DataCatalog.with_key(@john.primary_api_key) do
        Report.update(@report.id, :status => "open")
      end
      refreshed_report = Report.get(@report.id)
      refreshed_report.text.should == "Report 1 by John"
      refreshed_report.status.should == "open"
    end
  end

end
