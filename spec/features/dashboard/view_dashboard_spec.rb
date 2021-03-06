RSpec.feature 'View the dashboard page', type: :feature, js: true do

  before(:each) do
    @user = FactoryGirl.create(:user)
  end

  context 'before logging in' do
    it 'shows the welcome page as root page' do
      visit root_path
      expect(page).not_to have_content(@user.name)
      expect(page.find('.pageheader')).to have_content('Manage your expenses')
    end
  end

  context 'after logging in' do
    it 'shows the dashboard page as root page' do
      login(@user)
      expect(page).to have_content(@user.name)
      expect(page.find('.pageheader')).to have_content("Welcome #{@user.name}")
    end
  end

end
