require_relative '../rails_helper'

describe "the signin process" do
  let!(:user) { create :user }

  it "signs me in" do
    visit '/users/sign_in'
    fill_in 'Email', with: 'user@example.com'
    fill_in 'Password', with: 'password'

    click_button 'Log in'
    expect(page).to have_content 'Signed in successfully.'
  end

  it "signs me out" do
    login_as user

    visit tasks_path

    click_button 'Sign out'
    expect(page).to have_button 'Log in'
  end
end
