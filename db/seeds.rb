require 'digest/md5'
require 'open-uri'
require 'faker'

# Configure SQLite for better concurrency
ActiveRecord::Base.connection.execute('PRAGMA busy_timeout = 15000')

def gravatar_url(email, size = 200)
  email = email.downcase.strip
  hash = Digest::MD5.hexdigest(email)
  "https://www.gravatar.com/avatar/#{hash}?s=#{size}&d=404"
end

puts "🚀 Starting database seeding process..."

# Admin User Data
admin_data = {
  username: "Sachin Gevariya",
  email: "s.gevariya@gmail.com",
  role: "admin",
  first_name: "Sachin",
  last_name: "Gevariya",
  password: "essence@123"
}

puts "\n👤 Creating admin user and profile..."
ActiveRecord::Base.transaction do
  # Create User
  admin = User.find_or_initialize_by(email: admin_data[:email])
  if admin.new_record?
    admin.assign_attributes(admin_data.slice(:username, :email, :role)
      .merge(password: admin_data[:password], password_confirmation: admin_data[:password]))
    admin.save!
    puts "✅ Created admin user: #{admin.username}"
  else
    puts "👤 Admin user already exists"
  end

  # Create Profile
  profile = admin.build_profile if admin.profile.nil?
  profile.assign_attributes(
    first_name: admin_data[:first_name],
    last_name: admin_data[:last_name],
    phone: "1234567890",
    address: "Default Address"
  )
  
  if !profile.persisted?
    profile.save!
    puts "📋 Profile created for admin"
  end

  # Attach Avatar
  puts "🖼️ Setting up admin avatar..."
  begin
    avatar_url = gravatar_url(admin_data[:email])
    file = URI.open(avatar_url)
    profile.avtar.attach(io: file, filename: "sachin-gevariya.jpg", content_type: 'image/jpeg')
    puts "✅ Successfully attached admin avatar"
  rescue OpenURI::HTTPError => e
    puts "⚠️ Could not fetch Gmail profile picture"
  end
end

puts "\n🏷️ Creating nature tags..."
nature_tags = %w[mountain forest ocean sunset sunrise river waterfall beach nature wildlife]

tags = []
nature_tags.each do |tag_name|
  tag = Tag.find_or_create_by!(name: "##{tag_name}")
  tags << tag
  puts "🏷️ Created tag: ##{tag_name}"
end

puts "\n📸 Creating posts for admin..."
admin = User.find_by(email: admin_data[:email])

4.times do |i|
  post = admin.posts.new(
    title: Faker::Lorem.sentence(word_count: 5),
    description: Faker::Lorem.paragraph(sentence_count: 3)
  )

  puts "📝 Creating post #{i+1}/4..."
  begin
    image_url = "https://picsum.photos/800/600?nature"
    file = URI.open(image_url)
    post.image.attach(io: file, filename: "nature_post_#{Time.now.to_i}.jpg", content_type: 'image/jpeg')
    post.save!(validate: false)
    
    # Assign 2-4 random tags to each post
    tag_count = rand(2..4)
    post.tags << tags.sample(tag_count)
    puts "✅ Created post '#{post.title}' with #{tag_count} tags"
  rescue StandardError => e
    puts "❌ Error creating post: #{e.message}"
  end
  
  sleep(1) # Small delay between posts
end

puts "\n🎉 Database seeding completed successfully!"