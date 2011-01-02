Given /^(?:|I )am logged out$/ do
  visit destroy_user_session_path
end

Given /^(?:|I )sign up with email "([^"]*)" and password "([^"]*)"$/ do |email, password|
  Given "I go to the new user registration page"
  And "I fill in \"Email address\" with \"#{email}\""
  And "I fill in \"Password\" with \"#{password}\""
  And "I fill in \"Password confirmation\" with \"#{password}\""
  And "I press \"Sign up\""
  Then "I should be on the sign in page"
  And "I should see \"You have registered successfully\""
end

Given /^(?:|I )sign in as "([^"]*)" with password "([^"]*)"$/ do |email, password|
  Given "I go to the sign in page"
  And "I fill in \"Email address\" with \"#{email}\""
  And "I fill in \"Password\" with \"#{password}\""
  And "I press \"Login\""
  Then "I should be on the home page"
  And "I should see \"Signed in successfully\""
end

Given /^there exists a confirmed user with email "([^"]*)" and password "([^"]*)"/  do |email, password|
  user = User.new(:email => email, :password => password)
  user.confirmed_at = Time.now
  user.save!
end
