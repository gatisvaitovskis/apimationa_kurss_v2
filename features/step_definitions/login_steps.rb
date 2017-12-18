When(/^I login apimation$/) do
  login_positive
end

Then(/^I can access my info$/) do
  check_personal_info
end

Then(/^I try to log in apimation.com with a wrong password$/) do
  login_wrong_password
end

Then(/^I check if I am not logged in and I cannot access my data$/) do
  check_user_not_logged
end
