require_relative '../feature_helper'

feature 'Tasks' do
  around(:each) do |example|
    ActiveRecord::Base.connection.transaction do
      User.create(
        username: 'pesho999',
        email: 'pesho999@pesho999.com',
        password: '1234567')

      visit '/login'
      fill_in 'username', with: 'pesho999'
      fill_in 'password', with: '1234567'

      click_button 'Login'

      example.run

      raise ActiveRecord::Rollback
    end
  end

  let(:user) { User.find_by(username: 'pesho999') }

  scenario 'Lists url and frequency for already added tasks' do
    url = 'fmi.ruby.bg'
    frequency = 30

    user.tasks.create(
      frequency: frequency,
      page: Page.find_by(url: url) || Page.create(url: url))

    visit '/tasks'

    expect(page).to have_content(url)
    expect(page).to have_content(frequency)
  end

  scenario 'Adds a task and lists its url and frequency' do
    url = 'fmi.ruby.bg'
    frequency = 30

    visit '/tasks/new'
    fill_in 'url', with: url
    fill_in 'frequency', with: frequency

    click_button 'Add'

    expect(page).to have_content(url)
    expect(page).to have_content(frequency)
  end
end
