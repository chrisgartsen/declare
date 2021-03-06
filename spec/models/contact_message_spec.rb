RSpec.describe ContactMessage, type: :model do

  it 'requires an email' do
    contact_message = FactoryGirl.build(:contact_message, :missing_email)
    contact_message.valid?
    expect(contact_message.errors[:email]).to include("can't be blank")
  end

  it 'requires the email to be valid format' do
    contact_message = FactoryGirl.build(:contact_message, :invalid_email_format)
    contact_message.valid?
    expect(contact_message.errors[:email]).to include("does not appear to be a valid e-mail address")
  end

  it 'requires a message' do
    contact_message = FactoryGirl.build(:contact_message, :missing_message)
    contact_message.valid?
    expect(contact_message.errors[:message]).to include("can't be blank")
  end

  it 'saves to the database with valid attributes' do
    expect{FactoryGirl.create(:contact_message)}.to change(ContactMessage, :count).by(1)
  end

end
