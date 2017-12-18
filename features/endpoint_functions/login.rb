require 'rest-client'
require 'test-unit'

def login_positive
  login_payload = { login: @test_user.email,
                    password: @test_user.password }.to_json

  response = post('http://www.apimation.com/login',
                  headers: { 'Content-Type' => 'application/json' },
                  cookies: {},
                  payload: login_payload)
  assert_equal(200, response.code, "Strādā bet tomēr nē! #{response}")

  response_hash = JSON.parse(response)
  @test_user.set_user_id(response_hash['user_id'])

  assert_equal(@test_user.email, response_hash['email'], 'Emails nava labs !')
  assert_not_equal(nil, response_hash['user_id'], 'User ID nava labs !')
  assert_equal(@test_user.email, response_hash['login'], 'User ID nava labs !')

  @test_user.set_session_cookie(response.cookies)
end

def check_personal_info
  response = get('http://apimation.com/user',
                 headers: {},
                 cookies: @test_user.session_cookie)
  assert_equal(200, response.code, "Strādā bet tomēr nē! #{response}")

  user_response_hash = JSON.parse(response)

  assert_equal(@test_user.user_id.to_s, user_response_hash['user_id'].to_s, "lietotāja ID nesakrīt! #{response}")
  assert_equal(@test_user.email.to_s, user_response_hash['login'].to_s, "Lietotāja epasti nesakrīt! #{response}")
end

def login_wrong_password
  login_payload = { login: @test_user.email,
                    password: 'password_test'}.to_json

  response = post('http://www.apimation.com/login',
                  headers: { 'Content-Type' => 'application/json'},
                  cookies: {},
                  payload: login_payload)

  # Check if eroor code 400 is received
  assert_equal(400, response.code, "Wrong error code! #{response}")
  response_hash = JSON.parse(response)

  assert_equal('002', response_hash['error-code'], 'Error code in response is not correct!')
  assert_equal('Username or password is not correct', response_hash['error-msg'], 'Error message is not correct!')

  @test_user.set_session_cookie(response.cookies)
end

def check_user_not_logged
  response = get('http://apimation.com/user',
                 headers: {},
                 cookies: @test_user.session_cookie)

  response_hash = JSON.parse(response)
  assert_equal('No session', response_hash['error-msg'], 'Error message is not correct!')
end