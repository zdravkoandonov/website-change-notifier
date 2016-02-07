require_relative '../feature_helper'

feature 'Registration' do
  around(:each) do |example|
    ActiveRecord::Base.connection.transaction do
      example.run

      raise ActiveRecord::Rollback
    end
  end

  scenario 'Shows welcome message on top if everything is fine' do
    user = User.create(
        username: 'pesho999',
        email: 'pesho999@pesho999.com',
        password: '1234567')

    visit '/register'

    fill_in 'email', with: 'pesho9991@pesho999.com'
    fill_in 'username', with: 'pesho9991'
    fill_in 'password', with: 'asdfasdf'

    click_button 'Register'

    expect(page).to have_content('Welcome, pesho9991')
  end

  scenario 'Redirects to /tasks if everything is fine' do
    user = User.create(
        username: 'pesho999',
        email: 'pesho999@pesho999.com',
        password: '1234567')

    visit '/register'

    fill_in 'email', with: 'pesho9991@pesho999.com'
    fill_in 'username', with: 'pesho9991'
    fill_in 'password', with: 'asdfasdf'

    click_button 'Register'

    expect(page).to have_current_path('/tasks')
  end

  scenario 'Shows error message if username is taken' do
    user = User.create(
        username: 'pesho999',
        email: 'pesho999@pesho999.com',
        password: '1234567')

    visit '/register'

    fill_in 'email', with: 'pesho9991@pesho999.com'
    fill_in 'username', with: 'pesho999'
    fill_in 'password', with: 'asdfasdf'

    click_button 'Register'

    expect(page).to have_content('Username has already been taken')
  end

  scenario 'Shows error message if email is already in use' do
    user = User.create(
        username: 'pesho999',
        email: 'pesho999@pesho999.com',
        password: '1234567')

    visit '/register'

    fill_in 'email', with: 'pesho999@pesho999.com'
    fill_in 'username', with: 'pesho9991'
    fill_in 'password', with: '1234567'

    click_button 'Register'

    expect(page).to have_content('Email has already been taken')
  end

  scenario 'Shows error message if username is not entered' do
    visit '/register'

    fill_in 'email', with: 'pesho999@pesho999.com'
    fill_in 'password', with: '1234567'

    click_button 'Register'

    expect(page).to have_content("Username can't be blank")
  end

  scenario 'Shows error message if email is not entered' do
    visit '/register'

    fill_in 'username', with: 'pesho999'
    fill_in 'password', with: '1234567'

    click_button 'Register'

    expect(page).to have_content("Email can't be blank")
  end
end
