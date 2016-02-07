require_relative 'spec_helper'

feature 'Signing in' do
  around(:each) do |example|
    ActiveRecord::Base.connection.transaction do
      example.run
      raise ActiveRecord::Rollback
    end
  end

  scenario 'Redirects to /tasks if correct credentials are passed' do
    user = User.create(
      username: 'pesho999',
      email: 'pesho999@pesho999.com',
      password: '1234567')

    visit '/login'
    fill_in 'username', with: 'pesho999'
    fill_in 'password', with: '1234567'

    click_button 'Login'

    expect(page).to have_current_path('/tasks')
  end
end
