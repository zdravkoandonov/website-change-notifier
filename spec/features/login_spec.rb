require_relative '../feature_helper'

feature 'Signing in' do
  around(:each) do |example|
    ActiveRecord::Base.connection.transaction do
      User.create(
        username: 'pesho999',
        email: 'pesho999@pesho999.com',
        password: '1234567')

      example.run

      raise ActiveRecord::Rollback
    end
  end

  scenario 'Shows welcome message on top if correct credentials are passed' do
    visit '/login'
    fill_in 'username', with: 'pesho999'
    fill_in 'password', with: '1234567'

    click_button 'Login'

    expect(page).to have_content('Welcome, pesho999')
  end

  scenario 'Redirects to /tasks if correct credentials are passed' do
    visit '/login'
    fill_in 'username', with: 'pesho999'
    fill_in 'password', with: '1234567'

    click_button 'Login'

    expect(page).to have_current_path('/tasks')
  end

  scenario 'Redirects to /login if incorrect password is passed' do
    visit '/login'
    fill_in 'username', with: 'pesho999'
    fill_in 'password', with: '7654321'

    click_button 'Login'

    expect(page).to have_current_path('/login')
  end

  scenario 'Redirects to /login if incorrect username is passed' do
    visit '/login'
    fill_in 'username', with: 'pesho13'
    fill_in 'password', with: '1234567'

    click_button 'Login'

    expect(page).to have_current_path('/login')
  end
end
