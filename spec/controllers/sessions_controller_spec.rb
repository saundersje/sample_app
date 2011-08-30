require 'spec_helper'

describe SessionsController do
  render_views

  describe "POST 'create'" do
    
    describe "with valid email and password" do
      before(:each) do
        @user = Factory(:user)
        @attr = { :email => @user.email, :password => @user.password }
      end
      
      it "should sign the user in"do
        post :create, :session => @attr
        controller.current_user.should == @user
        controller.should be_signed_in
      end
      
      it "should redirect to the user show page" do
        post :create, :session => @attr
        response.should redirect_to(user_path(@user))
      end
    end
    
    
    describe "invalid signin" do
      before(:each) do
        @attr = { :email => "example@example.com", :password => "invalid" }
      end
      
      it "should re-render the new page" do
        post :create, :session => @attr
        response.should render_template('new')
      end
      
      it "should have the right title" do
        post :create, :session => @attr
        response.should have_selector("title", :content => "Sign in")
      end
      
      it "should have a flsah.now message" do
        post :create, :session => @attr
        flash.now[:error].should =~ /invalid/i
      end
    end  
  end
  
  
  describe "GET 'new'" do
    
    it "should be successful" do
      get :new
      response.should be_success
    end
    
    it "should have the right title" do
      get :new
      response.should have_selector("title", :content => "Sign in")
    end
  end
  
  describe "DELETE 'destroy'" do
    
    it "should sign a user out" do
      delete :destroy
      controller.should_not be_signed_in
      response.should redirect_to(root_path)
    end
  end

end
