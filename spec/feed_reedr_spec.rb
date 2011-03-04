require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "FeedReedr" do
  before do
    FeedReedr::Base.stub(:root_path).and_return(File.join(File.dirname(__FILE__), 'support'))
  end

  it "calls load_yaml on initialize" do
    FeedReedr::Base.should_receive(:load_yaml)
    FeedReedr::Base.new
  end

  it "loads the server_type" do
    @feed_reedr = FeedReedr::Base.new
    @feed_reedr.config["server_type"].should == 'ftp'
  end

  context 'fetchr' do
    before do
      @feed_reedr = FeedReedr::Base.new
    end

    it "instantiates a fetchr object" do
      FeedReedr::Fetchr.should_receive(:new)
      @feed_reedr.fetchr
    end

    it "always returns the same fetchr object" do
      @feed_reedr.fetchr.should equal(@feed_reedr.fetchr)
    end

    it "uses an ftp connection for an ftp server_type" do
      Net::FTP.stub(:new).and_return(stub(Net::FTP, {:close => nil, :getbinaryfile => nil}))
      Net::FTP.should_receive(:new).with(@feed_reedr.config["server"], @feed_reedr.config["username"], @feed_reedr.config["password"])
      @feed_reedr.fetchr.fetch
    end
  end
end
