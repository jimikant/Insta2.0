require 'digest/md5'
require 'open-uri'

def gravatar_url(email, size = 200)
  hash = Digest::MD5.hexdigest(email.downcase.strip)
  "https://www.gravatar.com/avatar/#{hash}?s=#{size}&d=identicon"
end

users = [
  { username: "Sachin Gevariya", email: "s.gevariya@gmail.com", role: "admin", first_name: "Sachin", last_name: "Gevariya" },
  { username: "essence", email: "essence@gmail.com", role: "user", first_name: "Essence", last_name: "Solusoft" }
]

password = "essence@123"

users.each do |user_attrs|
  user = User.find_or_initialize_by(email: user_attrs[:email])

  if user.new_record?
    user.assign_attributes(user_attrs.slice(:username, :email, :role).merge(password: password, password_confirmation: password))
    user.save!
    puts "✅ Created user: #{user.username} (#{user.role})"
  else
    puts "🔹 User already exists: #{user.username} (#{user.role})"
  end

  # 🔥 Ensure profile exists and set required fields
  profile = user.build_profile if user.profile.nil?
  profile.assign_attributes(
    first_name: user_attrs[:first_name],
    last_name: user_attrs[:last_name],
    phone: "1234567890",   # Dummy phone number (update as needed)
    address: "Default Address" # Dummy address (update as needed)
  )
  profile.save! unless profile.persisted?

  # 🔥 Attach the profile avatar from Gravatar
  avatar_url = gravatar_url(user.email)
  
  begin
    file = URI.open(avatar_url)
    profile.avtar.attach(io: file, filename: "#{user.username.parameterize}.jpg", content_type: 'image/jpeg')
    puts "🖼️ Profile picture set for: #{user.username}"
  rescue OpenURI::HTTPError => e
    puts "⚠️ Could not fetch profile picture for #{user.username}: #{e.message}"
  end
end
