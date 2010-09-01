share_examples_for "A property with flags" do
  before :all do
    %w[ @property_klass ].each do |ivar|
      raise "+#{ivar}+ should be defined in before block" unless instance_variable_defined?(ivar)
    end

    @flags = [ :one, :two, :three ]

    class ::User
      include DataMapper::Resource
    end

    @property = User.property :item, @property_klass[@flags], :key => true
  end

  describe ".generated_classes" do
    it "should cache the generated class" do
      @property_klass.generated_classes[@flags].should_not be_nil
    end
  end

  it "should include :flags in accepted_options" do
    @property_klass.accepted_options.should include(:flags)
  end

  it "should respond to :generated_classes" do
    @property_klass.should respond_to(:generated_classes)
  end

  it "should respond to :flag_map" do
    @property.should respond_to(:flag_map)
  end

  it "should be custom" do
    @property.custom?.should be(true)
  end
end
