require 'rest-client'
require 'test-unit'

def create_new_project(name, type)
  time = Time.now
  login_payload = { 'name' => name + time.strftime(' %Y/%m/%d %H:%M:%S').to_s,
                    'type' => type }.to_json
  response = post("http://apimation.com/projects",
                  headers: { 'Content-Type' => 'application/json' },
                  cookies: @test_user.session_cookie,
                  payload: login_payload)
  puts login_payload

  # Check if new project is successfully created
  assert_equal(200, response.code, "Problem to create new project! #{response}")

  response_hash = JSON.parse(response)
  # Returns project object
  Project.new(response_hash['id'])
end

def set_project_as_active(project_id)
  delete_active_project = delete("http://apimation.com/environments/active",
                                 headers: { 'Content-Type' => 'application/json' },
                                 cookies: @test_user.session_cookie)
  assert_equal(204, delete_active_project.code, "Problem to set active project! #{delete_active_project}")

  set_active_project = put("http://apimation.com/projects/active/#{project_id}",
                           headers: { 'Content-Type' => 'application/json' },
                           cookies: @test_user.session_cookie)


  assert_equal(204, set_active_project.code, "Problem to set active project! #{set_active_project}")
end

def create_new_environment(project, name)
  login_payload = { 'name' => name }.to_json
  response = post("http://apimation.com/environments",
                  headers: { 'Content-Type' => 'application/json' },
                  cookies: @test_user.session_cookie,
                  payload: login_payload)

  response_hash = JSON.parse(response)

  # Check if new invironment is successfully created
  assert_equal(200, response.code, "Problem to create new environment! #{response}")

  project.environments.push(response_hash['id'])
  puts project.environments
end

def add_global_variable(project, data)
  project.environments.each do |project_ids|
  set_active_environment = put("http://apimation.com/environments/active/#{project_ids}",
                               cookies: @test_user.session_cookie)

  global_variable_payload = { 'global_vars' => data }

  add_global_response = put("http://apimation.com/environments/#{project_ids}",
                               headers: { 'Content-Type' => 'application/json' },
                               cookies: @test_user.session_cookie,
                               payload: global_variable_payload.to_json)
  assert_equal(204, add_global_response.code, "Problem adding apimation global variable! #{add_global_response}")

  end

  def delete_all_environments(project)
    project.environments.each do |env_ids|
    delete_environments = delete("http://apimation.com/environments/#{env_ids}",
                                   headers: { 'Content-Type' => 'application/json' },
                                   cookies: @test_user.session_cookie)

    end
  end
end