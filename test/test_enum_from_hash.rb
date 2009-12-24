require File.join(File.dirname(__FILE__), 'setup_test')

class Box < ActiveRecord::Base
  enum_from_hash :material, {:stone => 1, :cardboard => 2, :wood => 3}
  enum_from_hash :size, {:small => 0, :medium => 3, :large => 10, :huge => 11, :enormous => 100}
end

context 'An ActiveRecord module using enum_from_hash with field name corresponding to column' do
  setup {@inst = Box.new}
  
  specify 'should create a constant for the hash' do
    Box::MATERIALS.is_a?(Hash).should.be true
  end  
  
  specify 'should create constants for each value in the hash' do
    Box::MATERIALS.each do |k, v|
      Box.const_get(k.to_s.upcase).should == v
    end
  end
    
  specify 'should create an instance setter that allows setting via symbol' do
    Box::MATERIALS.each do |k, v|
      @inst.material = k
      @inst.material.should == v
    end
  end
    
  specify 'should create an instance setter that allows setting via string' do
    Box::MATERIALS.each do |k, v|
      @inst.material = k.to_s
      @inst.material.should == v
    end
  end
  
  
  specify 'should create an instance setter that allows setting via integer string' do
    Box::MATERIALS.each do |k, v|
      @inst.material = v.to_s
      @inst.material.should == v
    end
  end
  
  specify 'should create an instance setter that allows setting via integer' do
    Box::MATERIALS.each do |k, v|
      @inst.material = v
      @inst.material.should == v
    end
  end
  
  specify 'should created instance predicate methods for each key in the hash' do
    Box::MATERIALS.each do |k, v|
      @inst.material = k
      @inst.send("#{k}?").should.be true
      Box::MATERIALS.keys.each do |k1|
        @inst.send("#{k}?").should.be true unless k == k1
      end
    end
  end
  
  specify 'should create a name instance method returning human readable version' do
    Box::MATERIALS.each do |k, v|
      @inst.material = v
      @inst.material_name.should == k.to_s
    end
  end
    
  specify 'should validate that value is in the hash' do
    val = 0
    val += 1 while Box::MATERIALS.values.include?(val)
    @inst.material = val
    @inst.should.not.be.valid
    @inst.errors.on(:material).should.not.be.nil
  end
end

context 'An ActiveRecord module using enum_from_hash with field name corresponding to column + _id' do
  setup {@inst = Box.new}
  
  specify 'should create a constant for the hash' do
    Box::SIZES.is_a?(Hash).should.be true
  end  
  
  specify 'should create constants for each value in the hash' do
    Box::SIZES.each do |k, v|
      Box.const_get(k.to_s.upcase).should == v
    end
  end
  
  specify 'should create an instance setter that allows setting via symbol' do
    Box::SIZES.each do |k, v|
      @inst.size = k
      @inst.size.should == k.to_s
      @inst.size_id.should == v
    end
  end
  
  specify 'should created instance predicate methods for each key in the hash' do
    Box::SIZES.each do |k, v|
      @inst.size = k
      @inst.send("#{k}?").should.be true
      Box::SIZES.keys.each do |k1|
        @inst.send("#{k}?").should.be true unless k == k1
      end
    end
  end
  
  specify 'should create a name instance method returning human readable version' do
    Box::SIZES.each do |k, v|
      @inst.size = v
      @inst.size_name.should == k.to_s
    end
  end
  
  specify 'should validate that value is in the hash' do
    val = 0
    val += 1 while Box::SIZES.values.include?(val)
    @inst.size = val
    @inst.should.not.be.valid
    @inst.errors.on(:size_id).should.not.be.nil
  end
end
