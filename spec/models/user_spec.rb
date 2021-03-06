require 'rails_helper'

RSpec.describe User, type: :model do

  it 'requires a name' do
    user = FactoryGirl.build(:user, :missing_name)
    user.valid?
    expect(user.errors[:name]).to include("can't be blank")
  end

  it 'has a unique name' do
    FactoryGirl.create(:user)
    user = FactoryGirl.build(:user)
    user.valid?
    expect(user.errors[:name]).to include("has already been taken")
  end

  it 'requires an email' do
    user = FactoryGirl.build(:user, :missing_email)
    user.valid?
    expect(user.errors[:email]).to include("can't be blank")
  end

  it 'has a unique email' do
    FactoryGirl.create(:user)
    user = FactoryGirl.build(:user)
    user.valid?
    expect(user.errors[:email]).to include("has already been taken")
  end

  it 'requires a password' do
    user = FactoryGirl.build(:user, :missing_password)
    user.valid?
    expect(user.errors[:password]).to include("can't be blank")
  end

  it 'requires a password confirmation to match password' do
    user = FactoryGirl.build(:user, :password_mismatch)
    user.valid?
    expect(user.errors[:password_confirmation]).to include("doesn't match Password")
  end

  it 'is not an admin by default' do
    user = FactoryGirl.create(:user)
    expect(user.admin).to be_falsey
  end

  it 'is inactive by default' do
    user = FactoryGirl.create(:user)
    expect(user.active).to be_falsey
  end

  it 'saves to the database when valid' do
    expect{FactoryGirl.create(:user)}.to change(User, :count).by(1)
  end

  it 'stores the password salt and hash' do
    user = FactoryGirl.create(:user)
    expect(user.password_salt).not_to be_nil
    expect(user.password_hash).not_to be_nil
  end

  it 'has a hashed password' do
    user = FactoryGirl.create(:user)
    expect(user.password_hash).to eq(BCrypt::Engine.hash_secret('Secret', user.password_salt))
  end

  it 'activates the user' do
    user = FactoryGirl.create(:user, :inactive)
    user.activate
    expect(user.active).to be_truthy
  end

  it 'inactivates the user' do
    user = FactoryGirl.create(:user, :active)
    user.inactivate
    expect(user.active).to be_falsey
  end

  it 'authenticates with the correct password' do
    user = FactoryGirl.create(:user)
    expect(user.authenticate(user.password)).to be_truthy
  end

  it 'does not authenticate with the wrong password' do
    user = FactoryGirl.create(:user)
    expect(user.authenticate('WRONG')).to be_falsey
  end

  it 'does not authenticate without a password' do
    user = FactoryGirl.create(:user)
    expect(user.authenticate(nil)).to be_falsey
  end

  it 'returns the number of projects' do
    user = FactoryGirl.create(:user)
    second_user = FactoryGirl.create(:additional_user)
    FactoryGirl.create(:first_project, user_id: user.id)
    FactoryGirl.create(:second_project, user_id: user.id)
    FactoryGirl.create(:third_project, user_id: second_user.id)
    expect(user.number_of_projects).to eq(2)
  end

  it 'returns the users projects' do
    user = FactoryGirl.create(:user)
    second_user = FactoryGirl.create(:additional_user)
    first_project = FactoryGirl.create(:first_project, user_id: user.id)
    second_project = FactoryGirl.create(:second_project, user_id: user.id)
    FactoryGirl.create(:third_project, user_id: second_user.id)
    expect(user.projects).to match_array([first_project, second_project])
  end

  it 'returns the users expenses' do
    @user = FactoryGirl.create(:user)
    @project = FactoryGirl.create(:project, user: @user)
    @second_project = FactoryGirl.create(:project, user: FactoryGirl.create(:additional_user))
    @third_project = FactoryGirl.create(:second_project, user: @user)
    @expense_type = FactoryGirl.create(:expense_type)
    @payment_type = FactoryGirl.create(:payment_type)
    @currency = FactoryGirl.create(:currency)

    @first_expense = FactoryGirl.create(:expense, project: @project, expense_type: @expense_type,
                                                 payment_type: @payment_type, currency: @currency)
    @second_expense = FactoryGirl.create(:expense, project: @project, expense_type: @expense_type,
                                                 payment_type: @payment_type, currency: @currency)
    @third_expense = FactoryGirl.create(:expense, project: @second_project, expense_type: @expense_type,
                                                 payment_type: @payment_type, currency: @currency)
    @forth_expense = FactoryGirl.create(:expense, project: @third_project, expense_type: @expense_type,
                                                 payment_type: @payment_type, currency: @currency)

    expect(@user.expenses).to match_array([@first_expense, @second_expense, @forth_expense])

  end


end
