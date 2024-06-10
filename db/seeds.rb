# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

['ansis', 'grieta', 'anna'].each do |name|
  User.find_or_create_by!(email: "#{name}@test.com") do |user|
    user.password = 'Passw0rd'
  end
end

ansis = User.find_by(email: 'ansis@test.com')
grieta = User.find_by(email: 'grieta@test.com')

Task.find_or_create_by(name: 'Not for Anna', responsible: ansis, author: grieta) do |task|
  task.description = 'Anna does not see this task'
  task.deadline = Date.tomorrow
end

Task.find_or_create_by(name: 'Only Ansis', responsible: ansis, author: ansis) do |task|
  task.description = 'This task can only be accessed by Ansis'
  task.deadline = Date.tomorrow
end
