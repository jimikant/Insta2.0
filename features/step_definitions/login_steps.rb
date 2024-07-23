Given("I am on the login page") do
  visit new_user_session_path
end

When("I fill in {string} with {string}") do |field, value|
  # save_and_open_page
  fill_in field, with: value
end

When("I press {string}") do |button|
  click_button button
end

Then("I should see {string}") do |message|
  expect(page).to have_content(text)
end
