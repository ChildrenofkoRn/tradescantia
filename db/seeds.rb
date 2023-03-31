# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

if ENV.fetch("RAILS_ENV", "development") == "development"
  users = []
  13.times do
    users << FactoryBot.create(:user, username: Faker::Books::Dune.planet.tr(" \"'", "_"))
  rescue ActiveRecord::RecordInvalid
    redo
  end

  70.times do
    title = Faker::Book.title
    body  = Faker::Lorem.paragraph(sentence_count: 40, supplemental: true)
    FactoryBot.create(:review, author: users.sample, title: title, body: body)
  rescue ActiveRecord::RecordInvalid
    redo
  end
end
