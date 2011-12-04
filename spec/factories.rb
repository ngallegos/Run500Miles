# By using the symbol ':user', we get Factory Girl to simulate the User model.
Factory.define :user do |user|
  user.fname                  "Nick"
  user.lname                  "Gallegos"
  user.email                 "nick.gallegos@example.com"
  user.password              "foobar"
  user.password_confirmation "foobar"
  user.secret_word "angusbeef"
end