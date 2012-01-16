Garnet::User.blueprint do
  name { "name #{sn}"}
  email { "#{sn}@example.com" }
  token { sn }
end
