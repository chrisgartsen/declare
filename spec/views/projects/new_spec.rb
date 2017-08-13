RSpec.describe 'projects/new', type: :view do

  describe '#markup' do

    let(:breadcrumb) { view.content_for(:breadcrumb) }

    before(:each) do
      assign(:project, Project.new)
      render
    end

    it 'has a link back to the project index page' do
      expect(breadcrumb).to have_link('Projects', href: projects_path )
    end

    it 'has a static reference to the create page' do
      expect(breadcrumb).to have_selector('.breadcrumb li.is-active a', text: 'Add Project' )
    end

    it 'has a page header' do
      expect(rendered).to have_selector('.pageheader', text: 'Add project')
    end

  end

  describe '#form' do

    before(:each) do
      assign(:project, Project.new)
      render
    end

    it 'has a form' do
      expect(rendered).to have_selector('form')
    end

    it 'as a back button' do
      expect(rendered).to have_link('Back', href: projects_path)
    end

    it 'has a submit button' do
      expect(rendered).to have_selector("input[type='submit']")
    end

    it 'has a name field' do
      expect(rendered).to have_selector("input[type='text']#project_name")
    end

  end

  describe '#form with errors' do

    before(:each) do
      project = FactoryGirl.build(:project, :missing_name)
      project.valid?
      assign(:project, project)
      render
    end

     it 'has an error panel' do
      expect(rendered).to have_selector('article.message.is-danger')
    end

    it 'shows an error header' do
      expect(rendered).to have_selector('.message-header strong', text: 'A problem has occurred while saving this project.')
    end

   it 'shows an error subheader' do
      expect(rendered).to have_selector('.message-body strong', text: '1 error occurred')
    end

    it 'list the error' do
      expect(rendered).to have_selector('li', text: "Name can't be blank")
    end

    it 'lists the correct number of errors' do
      expect(rendered).to have_selector('li', count: 1)
    end

  end



end
