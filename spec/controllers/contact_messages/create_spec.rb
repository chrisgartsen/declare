RSpec.describe ContactMessagesController, type: :controller do

  describe 'POST #create' do

    context 'with valid input' do

      it 'stores a contact message in the database' do
        expect{
          post :create, params: {contact_message: FactoryGirl.attributes_for(:contact_message)}
          }.to change(ContactMessage, :count).by(1)
      end

      it 'redirects to a confirmation message' do
        post :create, params: {contact_message: FactoryGirl.attributes_for(:contact_message)}
        contact_message = ContactMessage.last
        expect(response).to redirect_to contact_message_path(contact_message)
      end

    end

    context 'with invalid input' do

      it 're-renders the create form' do
        post :create, params: { contact_message: FactoryGirl.attributes_for(:contact_message, :missing_email)}
        expect(response).to render_template(:new)
      end

      it 'does not create a record in the database' do
        expect {
            post :create, params: { contact_message: FactoryGirl.attributes_for(:contact_message, :missing_email)}
        }.not_to change(ContactMessage, :count)
      end

    end

  end

end
