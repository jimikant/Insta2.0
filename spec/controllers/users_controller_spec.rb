require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  before do
    # Mocking the create_stripe_customer_method_without_relying_on_the_actual_implementation
    allow_any_instance_of(User).to receive(:create_stripe_customer).and_return(true)
  end

  context 'when user is authenticated' do

    describe 'authorization' do
      let(:user) { create(:user) }

      before do
        sign_in user
        allow(controller).to receive(:authorize_user)
        get :user_index
      end

      it 'authorizes user before accessing user_index' do
        expect(controller).to have_received(:authorize_user).with(no_args)
      end
    end

    describe "GET #user_index" do
      let(:user) { create(:user) }

      before do
        sign_in user
      end

      # it 'assigns @users' do
      #   get :user_index
      #   puts "Assigned users: #{assigns(:users).inspect}"  # Debug output
      #   expect(assigns(:users)).to eq(User.all.user_asc_order)
      # end

      # it 'renders the user_index template' do
      #   get :user_index
      #   expect(response).to render_template(:user_index)
      # end
    end

    describe 'GET #dashboard' do
      let(:user) { create(:user) }

      before do
        sign_in user
      end

      it 'assigns @user and @posts' do
        get :dashboard
        expect(assigns(:user)).to eq(user)
        expect(assigns(:posts)).to eq(user.posts)
      end
    end

    # describe 'GET #show' do
    #   let(:user) { create(:user) }

    #   before do
    #     sign_in user
    #   end

    #   it 'assigns @user' do
    #     get :show, params: { id: user.friendly_id }
    #     expect(assigns(:user)).to eq(user)
    #   end

    #   it 'sets @can_like' do
    #     get :show, params: { id: user.friendly_id }
    #     expect(assigns(:can_like)).to be true
    #   end
    # end

    # describe 'GET #new' do
    # let(:user) { create(:user) }

    #   before do
    #     sign_in user
    #   end

    #   it 'assigns a new user' do
    #     get :new
    #     expect(assigns(:user)).to be_a_new(User)
    #   end
    # end

    # describe 'POST #create' do
    # let(:user) { create(:user) }

    #   before do
    #     sign_in user
    #   end

    #   context 'with valid params' do
    #     it 'creates a new User' do
    #       expect {
    #         post :create, params: { user: valid_attributes }
    #       }.to change(User, :count).by(1)
    #     end

    #     it 'redirects to user_index' do
    #       post :create, params: { user: valid_attributes }
    #       expect(response).to redirect_to(user_index_path)
    #       expect(flash[:notice]).to eq('User was successfully created.')
    #     end
    #   end

    #   context 'with invalid params' do
    #     it 'does not create a new User' do
    #       expect {
    #         post :create, params: { user: valid_attributes.merge(email: nil) }
    #       }.to change(User, :count).by(0)
    #     end

    #     it 'renders the new template' do
    #       post :create, params: { user: valid_attributes.merge(email: nil) }
    #       expect(response).to render_template(:new)
    #     end
    #   end
    # end

    # describe 'GET #edit' do
    # let(:user) { create(:user) }

    #   before do
    #     sign_in user
    #   end

    #   it 'assigns @user' do
    #     get :edit, params: { id: user.friendly_id }
    #     expect(assigns(:user)).to eq(user)
    #   end
    # end

    # describe 'PATCH #update' do
    # let(:user) { create(:user) }

    #   before do
    #     sign_in user
    #   end

    #   context 'with valid params' do
    #     it 'updates the user' do
    #       patch :update, params: { id: user.friendly_id, user: { username: "updateduser" } }
    #       user.reload
    #       expect(user.username).to eq("updateduser")
    #     end

    #     it 'redirects to user_index' do
    #       patch :update, params: { id: user.friendly_id, user: valid_attributes }
    #       expect(response).to redirect_to(user_index_path)
    #       expect(flash[:notice]).to eq('User updated!')
    #     end
    #   end

    #   context 'with invalid params' do
    #     it 'does not update the user' do
    #       patch :update, params: { id: user.friendly_id, user: { email: nil } }
    #       expect(user.reload.email).to_not be_nil
    #     end

    #     it 'renders the edit template' do
    #       patch :update, params: { id: user.friendly_id, user: { email: nil } }
    #       expect(response).to render_template(:edit)
    #     end
    #   end
    # end

    # describe 'DELETE #destroy' do
    # let(:user) { create(:user) }

    #   before do
    #     sign_in user
    #   end

    #   context 'when current_user is admin' do
    #     before { sign_in admin }

    #     it 'deletes the user and profile' do
    #       user_with_profile = create(:user_with_profile)
    #       expect {
    #         delete :destroy, params: { id: user_with_profile.friendly_id }
    #       }.to change(User, :count).by(-1)
    #     end

    #     it 'redirects to user_index' do
    #       delete :destroy, params: { id: user.friendly_id }
    #       expect(response).to redirect_to(user_index_path)
    #       expect(flash[:notice]).to eq("User and associated Data deleted successfully.")
    #     end
    #   end

    #   context 'when current_user is not admin' do
    #     it 'deletes the current_user' do
    #       expect {
    #         delete :destroy, params: { id: user.friendly_id }
    #       }.to change(User, :count).by(-1)
    #     end

    #     it 'redirects to root_path' do
    #       delete :destroy, params: { id: user.friendly_id }
    #       expect(response).to redirect_to(root_path)
    #       expect(flash[:notice]).to eq("User and associated Data deleted successfully.")
    #     end
    #   end
    # end

    # describe 'GET #settings' do
    # let(:user) { create(:user) }

    #   before do
    #     sign_in user
    #   end

    #   it 'assigns @user and @subscription' do
    #     get :settings
    #     expect(assigns(:user)).to eq(user)
    #     expect(assigns(:subscription)).to be_present
    #   end
    # end

  end
  context 'when user is not authenticated' do
      it 'redirects to the login page' do
        get :user_index
        expect(response).to redirect_to(new_user_session_path)
      end
  end

end
