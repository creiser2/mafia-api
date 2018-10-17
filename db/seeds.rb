# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

firstLob = Lobby.create(name: "seed-lobby", password: "123", protected: true)

firstUser = User.create(username: "Tony", lobby_id: firstLob.id, alive: true, role: "mafia")
