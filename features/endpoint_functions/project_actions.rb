require 'rest-client'
require 'test-unit'

def create_new_project(name, type)
  # Adding time stamp for unique project name
  time = Time.now

  # Creating login payload ( name + time)
  login_payload = { 'name' => name + time.strftime(' %Y/%m/%d %H:%M:%S').to_s,
                    'type' => type }.to_json
  response = post("http://apimation.com/projects",
                  headers: { 'Content-Type' => 'application/json' },
                  cookies: @test_user.session_cookie,
                  payload: login_payload)

  # Check if new project is successfully created
  assert_equal(200, response.code, "Problem to create new project! #{response}")

  response_hash = JSON.parse(response)
  # Returns project object
  puts response_hash
  Project.new(response_hash)
end

def set_project_as_active(project_id)
  # Delete active projects
  delete_active_project = delete("http://apimation.com/environments/active",
                                 headers: { 'Content-Type' => 'application/json' },
                                 cookies: @test_user.session_cookie)
  assert_equal(204, delete_active_project.code, "Problem to set active project! #{delete_active_project}")

  # Preparing active project for addding new environment
  set_active_project = put("http://apimation.com/projects/active/#{project_id}",
                           headers: { 'Content-Type' => 'application/json' },
                           cookies: @test_user.session_cookie)

  # Check if project is set to active
  assert_equal(204, set_active_project.code, "Problem to set active project! #{set_active_project}")
end

def create_new_environment(project, name)
  # Create login paylod
  login_payload = { 'name' => name }.to_json
  response = post("http://apimation.com/environments",
                  headers: { 'Content-Type' => 'application/json' },
                  cookies: @test_user.session_cookie,
                  payload: login_payload)

  response_hash = JSON.parse(response)

  # Check if new invironment is successfully created
  assert_equal(200, response.code, "Problem to create new environment! #{response}")

  # Add Environment ID to Project object
  project.environments.push(response_hash['id'])
end

def add_global_variable(project, data)
  # Iterating through project IDs for global environment setup
  project.environments.each do |project_ids|
    set_active_environment = put("http://apimation.com/environments/active/#{project_ids}",
                                 cookies: @test_user.session_cookie)

    # Creating global variable payload with Cucumber hash table data
    global_variable_payload = { 'global_vars' => data }

    # Adding global variables to environments
    add_global_response = put("http://apimation.com/environments/#{project_ids}",
                              headers: { 'Content-Type' => 'application/json' },
                              cookies: @test_user.session_cookie,
                              payload: global_variable_payload.to_json)
    assert_equal(204, add_global_response.code, "Problem adding apimation global variable! #{add_global_response}")

  end

  def delete_all_environments(project)
    # Iterating through projects, to delete all
    project.environments.each do |env_ids|
      delete_environments = delete("http://apimation.com/environments/#{env_ids}",
                                   headers: { 'Content-Type' => 'application/json' },
                                   cookies: @test_user.session_cookie)
    end
  end
end

def find_project_by_name(name)
  # Find all projects
  response = get("http://apimation.com/projects",
                      headers: { 'Content-Type' => 'application/json' },
                      cookies: @test_user.session_cookie)
  all_projects = JSON.parse(response)
  project_id = nil
  # Find project in array
  all_projects.each do |projekt|
    if projekt['name'].include? name
      project_id = projekt['id']
      break
    end
  end
  project_id
end

def create_new_test_collection(collection_name, step_name)

  # Creating collection payload
  test_collection_payload = {'name' => collection_name, 'description' =>''}

  # Creating collection
  collection_response = post("http://apimation.com/collections",
                             headers: { 'Content-Type' => 'application/json' },
                             cookies: @test_user.session_cookie,
                             payload: test_collection_payload.to_json)
  # Convert response to hash for finding collection ID
  collection_response_hash = JSON.parse(collection_response)

  # Creating step payload
  step_payload = {
      "name"=> step_name.to_s,
      "description"=> "",
      "request"=> {
          "method"=> "POST",
          "url"=> "http://www.apimation.com/login",
          "type"=> "raw",
          "body"=> "{\"login\":\"gatis.vaitovskis@gmail.com\",\"password\":\"password\"}\n",
          "binaryContent"=> {
              "value"=> "",
              "filename"=> ""
          },
          "urlEncParams"=> [
              {
                  "name"=> "",
                  "value"=> ""
              }
          ],
          "formData"=> [
              {
                  "type"=> "text",
                  "value"=> "",
                  "name"=> "",
                  "filename"=> ""
              }
          ],
          "headers"=> [
              {
                  "name"=> "Content-Type",
                  "value"=> "application/json"
              }
          ],
          "greps"=> [],
          "auth"=> {
              "type"=> "noAuth",
              "data"=> {}
          }
      },
      "paste"=> false,
      "collection_id"=> collection_response_hash['id'].to_s
  }

  # Creating step call
  step_response = post("http://apimation.com/steps",
                       headers: { 'Content-Type' => 'application/json' },
                       cookies: @test_user.session_cookie,
                       payload: step_payload.to_json)

  # Check if apimation step is added successfuly
  assert_equal(200, step_response.code, "Problem creating new step! #{step_response}")
end