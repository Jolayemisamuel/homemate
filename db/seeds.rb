landlord = Landlord.create!(
  name: 'Jane Doe'
)
contact = landlord.contacts.create!(
  title: 'Ms',
  first_name: 'Jane',
  last_name: 'Doe',
  role: 'Primary',
  email: 'admin@homemate.local',
  primary: true
)

user = User.new(
  username: 'admin',
  email: 'admin@homemate.local',
  password: 'homemate',
  password_confirmation: 'homemate',
  contact: contact
)
user.is_admin = true
user.save!

UserAssociation.create!(
  user: user,
  associable: landlord
)