require "spec_helper"

describe RedisSerialize do
  describe "dsl" do
    it "should add the #redis_serialize method" do
      expect {
        class Thing
          include RedisSerialize
          redis_serialize :some_list
        end
      }.not_to raise_error
    end
  end

  describe "when included" do
    let(:klass) {
      class Thing
        include RedisSerialize
        redis_serialize :some_list

        def id
          10
        end
      end

      Thing.new
    }

    it "should expose the redis key for the list" do
      klass.some_list_key.should == "thing:10:list:some_list"
    end

    describe "accessing the items" do
      it "should be an empty array" do
        klass.some_list.should be_an_instance_of(Array)
        klass.some_list.should == []
      end

      describe "when there are items" do
        before do
          REDIS.sadd("thing:10:list:some_list", "3")
          REDIS.sadd("thing:10:list:some_list", "1")
        end

        it "should be the items" do
          klass.some_list.should == ["1", "3"]
        end
      end
    end

    describe "#add" do
      it "should add items" do
        klass.some_list_add("1", "2", "3")

        REDIS.smembers("thing:10:list:some_list").should == ["1", "2", "3"]
      end

      it "should be unique" do
        klass.some_list_add("1", "2", "3")
        klass.some_list_add("3", "2", "1")

        REDIS.smembers("thing:10:list:some_list").should == ["1", "2", "3"]
      end
    end

    describe "#remove" do
      it "should remove a single item" do
        klass.some_list_add("1", "2", "3")

        klass.some_list_remove("1").should == true
        REDIS.smembers("thing:10:list:some_list").sort.should == %w(2 3).sort
      end
    end

    describe "#set" do
      it "should set the items" do
        REDIS.smembers("thing:10:list:some_list").should == []

        klass.some_list_set(["1", "2", "3"])

        REDIS.smembers("thing:10:list:some_list").should == ["1", "2", "3"]
      end
    end

    describe "#include?" do
      it "should be false" do
        klass.some_list_include?("1").should == false
      end

      describe "when it contains the item" do
        before do
          klass.some_list_add("1", "2")
        end

        it "should be true" do
          %w(1 2).each {|n| klass.some_list_include?(n).should == true }
        end
      end
    end

    describe "#size" do
      it "should be 0" do
        klass.some_list_size.should == 0
      end

      describe "when items are added" do
        before do
          klass.some_list_add("1", "2")
        end

        it "should be the number of items" do
          klass.some_list_size.should == 2
        end

        describe "when items are added that are already there" do
          before do
            klass.some_list_add("2", "3")
          end

          it "should be the number of unique items" do
            klass.some_list_size.should == 3
          end
        end
      end
    end
  end
end
