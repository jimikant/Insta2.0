require 'digest/md5'
require 'open-uri'
require 'faker'

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

nature_words = %w[
  forest river ocean mountain valley meadow tree flower grassland desert 
  waterfall hill glacier canyon reef jungle savanna tundra volcano lake 
  rain cloud wind sunrise sunset storm thunder lightning mist breeze
]
tags = []
20.times do
  tag_name = "##{nature_words.sample}" # Ensure name starts with '#'
  tags << Tag.find_or_create_by!(name: tag_name)
end
puts "🏷️ Created #{tags.count} nature-related tags."

# ✅ Create 4 posts per user
users.each do |user_attrs|
  user = User.find_by(email: user_attrs[:email])

  4.times do
    # Use `create` instead of `create!` to avoid exceptions
    post = user.posts.new(
      title: Faker::Lorem.sentence(word_count: 5),
      description: Faker::Lorem.paragraph(sentence_count: 3)
    )

    # Fetch and attach a nature image
    begin
      image_url = "https://picsum.photos/800/600" # Alternative: Unsplash URL
      puts "🔗 Fetching image from: #{image_url}"

      file = URI.open(image_url)
      puts "✅ Image successfully fetched!"

      post.image.attach(io: file, filename: "post_#{post.id}.jpg", content_type: 'image/jpeg')
    rescue OpenURI::HTTPError => e
      puts "⚠️ Could not fetch image for post: #{post.title}, error: #{e.message}"
    rescue StandardError => e
      puts "❌ Unexpected error: #{e.message}"
    end

    # **Force save without triggering validation**
    if post.save(validate: false)
      puts "✅ Created post: #{post.title} with ID #{post.id}"
    else
      puts "❌ Failed to save post: #{post.title}"
    end

    # Assign random tags (1 to 5 tags per post)
    post.tags << tags.sample(rand(1..5)) if post.persisted?
    puts "✅ Assigned #{post.tags.count} tags to #{post.title}"
  end
end