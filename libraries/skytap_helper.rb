def makeHeaders (user, pass)
  auth_string = Base64.strict_encode64(user+':'+pass)
  headers = ({'Authorization' => "Basic "+auth_string,
              'Content-Type' => 'application/json',
              'Accept' => 'application/json' })
  return headers
end
