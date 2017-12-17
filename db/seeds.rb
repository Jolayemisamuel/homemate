user = User.create!(
  first_name: 'Jane',
  last_name: 'Doe',
  username: 'admin',
  email: 'admin@homemate.local',
  password: 'homemate',
  password_confirmation: 'homemate'
)

landlord = Landlord.create!(
  name: 'Jane Doe'
)

UserAssociation.create!(
  user: user,
  associable: landlord
)