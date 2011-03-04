require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Fetchr" do
  before do
    FeedReedr::Base.stub(:root_path).and_return(File.join(File.dirname(__FILE__), '../support'))
    @fetchr = FeedReedr::Base.new.fetchr
  end

  context 'fetch with an ftp server_type' do
    before do
      @ftp = mock(Net::FTP)
      @ftp.stub(:close)
      Net::FTP.stub(:new).and_return(@ftp)
      @ftp.stub(:getbinaryfile).and_return(true)
    end

    it "calculates the filename based on the file_pattern option" do
      file_pattern = "<%= basename %>-acrazypattern-<%= date.strftime('%d%m%y') %>.<%= suffix %>"
      @fetchr.options[:file_pattern] = file_pattern
      date = Date.today
      @fetchr.options[:csv_basenames].each do |basename|
        filename = "#{basename}-acrazypattern-#{date.strftime('%d%m%y')}.csv"
        @fetchr.csv_filenames.should include(filename)
      end
    end

    it "downloads each csv file" do
      @fetchr.csv_filenames.each do |csv_file|
        @ftp.should_receive(:getbinaryfile).with(csv_file, File.join(Dir::tmpdir, csv_file)).and_return(true)
      end
      @fetchr.fetch
    end

    it "loads all downloaded csv files into a csv_files array" do
      @fetchr.fetch
      @fetchr.csv_files.count.should == 2
    end
  end
end
