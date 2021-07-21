# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Users
if User.count.zero?
  sample_dir = Rails.root.join 'vendor/sample_users'
  target_dir = Rails.root.join 'public/uploads/users'

  User.transaction do
    [
      ['user', 'Basic User', 'US', 'New York', 'Christopher Street'],
      ['admin', 'The Administrator', 'GB', 'Glasgow', 'George Square'],
      ['attacker', 'Bad User', 'SO', 'Jamaame', 'Unnamed Street']
    ].each do |row|
      username, full_name, country, city, street = *row
      picture = "#{username}.svg"

      user = User.create!(
        email: "#{username}@vulnerableapp.com",
        password: 'password',
        api_token: SecureRandom.hex(16),
        full_name: full_name,
        picture: picture,
        country_code: country,
        city: city,
        address: street
      )

      picture_dir = target_dir.join(user.id.to_s)
      FileUtils.mkdir_p picture_dir
      FileUtils.cp sample_dir.join(picture), picture_dir
    end

    User.find_by(email: 'admin@vulnerableapp.com').update!(admin: true)
    User.find_by(email: 'attacker@vulnerableapp.com').update!(locked: true)
  end
end

# Products
# rubocop:disable Metrics
if Product.count.zero?
  sample_dir = Rails.root.join 'vendor/sample_products'
  target_dir = Rails.root.join 'public/uploads/products'

  Product.transaction do
    [
      ['beer_can.svg', 2.20, 'Beer can', 'A can for beer'],
      ['beer_glass.svg', 1.00, 'Beer glass', 'A glass for beer'],
      ['bulgarian_flag.svg', 5.50, 'Bulgaria flag'],
      ['city_bike.svg', 600.00, 'City bike'],
      ['flash_drive.svg', 25.00, 'Flash drive', 'USB Flash Drive'],
      ['lithuania_flag.svg', 5.50, 'Lithuania flag'],
      ['memory_stick.svg', 26.70, 'Memory stick', 'Memory stick card'],
      ['netharlands_flag.svg', 5.50, 'Netherlands flag'],
      ['photo_cam.svg', 120.32, 'Photo camera', 'A modern style camera'],
      ['poland_flag.svg', 5.50, 'Poland flag'],
      ['repair_bot.svg', 249.00, 'Repair bot', 'Will repair something (or not)'],
      ['retro_cam.svg', 279.89, 'Twin-lens reflex camera', 'A retro-style camera'],
      ['road_bike.svg', 800.00, 'Road bike'],
      ['russian_flag.svg', 5.50, 'Russia flag'],
      ['sd_card.svg', 24.00, 'SD card'],
      ['security_bot.svg', 259.00, 'Security bot', 'Will protect you (maybe)'],
      ['soda_can.svg', 2.10, 'Soda can', 'And you can too'],
      ['ssd_drive.svg', 80.00, 'SSD Drive'],
      ['surveillance_cam.svg', 100.00, 'Surveillance camera'],
      ['yellow_duck.svg', 4.20, 'Yellow duck', 'Your best friend in the world']
    ].each do |row|
      product = Product.create!(
        picture: row[0],
        price: row[1],
        name: row[2],
        description: row[3]
      )

      picture_dir = target_dir.join(product.id.to_s)
      FileUtils.mkdir_p picture_dir
      FileUtils.cp sample_dir.join(row[0]), picture_dir
    end
  end
end
# rubocop:enable Metrics

# Orders
if Order.count.zero?
  Order.transaction do
    prng = Random.new
    User.all.each do |user|
      %i[confirmed received new].each do |status|
        products = Product.order('RAND()').limit(5)

        order = user.orders.create!(
          status: status,
          payment_method: (:dummy unless status == :new),
          shipped_at: (2.days.ago if status == :received),
          received_at: (1.day.ago if status == :received),
          created_at: (prng.rand(20) + 3).days.ago
        )
        products.each do |product|
          order.items.create!(
            product: product,
            price: product.price,
            count: prng.rand(4) + 1
          )
        end
      end
    end
  end
end

# Messages
if Management::Message.count.zero?
  Management::Message.transaction do
    Management::Message.create!(
      user: User.find_by(email: 'user@vulnerableapp.com'),
      name: 'Good user',
      email: 'user@vulnerableapp.com',
      message: 'This is a <b>good</b> message'
    )
    Management::Message.create!(
      user: User.find_by(email: 'admin@vulnerableapp.com'),
      name: 'Admin user',
      email: 'admin@vulnerableapp.com',
      message: 'This is a message from <b>admin</b> to <i>other</i> admins'
    )
    Management::Message.create!(
      user: User.find_by(email: 'attacker@vulnerableapp.com'),
      name: 'Bad user',
      email: 'user@vulnerableapp.com',
      message: 'This is a <a href="javascript:alert(document.cookie)">bad</a> message'
    )
  end
end
