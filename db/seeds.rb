# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

ayana = User.create(email: "ayana@ayana.com", name: "Ayana", image_url: "https://avatars1.githubusercontent.com/u/892860?s=460&v=4", bio: "i love art", password: "pw")

jenn = User.create(email: "jennifer@jennifer.com", name: "Jenn", image_url: "https://avatars0.githubusercontent.com/u/10600568?s=460&v=4", bio: "i love art", password: "pw")
