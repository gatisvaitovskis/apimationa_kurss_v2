Then(/^I create new project with name: (.*) and type: (.*)$/) do |name, type|
  @project = create_new_project(name, type)
  set_project_as_active(@project.project_id)
end

Then(/^I create new environment:$/) do |table|
  data = table.raw
  data.each { |environment| create_new_environment(@project, environment[0]) }
end

Then(/^I add global variables with parameters:$/) do |table|
  data = table.hashes
  add_global_variable(@project, data)
end

And(/^I delete all environments$/) do
  delete_all_environments(@project)
end

Then(/^I select project: (.*)$/) do |name|
  project_id = find_project_by_name(name)
  set_project_as_active(project_id)
end

Then(/^I create new collection: (.*) with step: (.*)$/) do |collection_name, step_name|
  create_new_test_collection(collection_name, step_name)
end