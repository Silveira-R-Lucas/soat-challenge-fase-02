# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'faker'

5.times do
  Product.create(
    name: Faker::Dessert.variety,
    category: 'Sobremesa',
    description: Faker::Dessert.flavor,
    quantity: 120,
    price: Faker::Commerce.price.to_f)
end

7.times do
  Product.create(
    name: Faker::Food.dish,
    category: 'Acompanhamentos',
    description: Faker::Food.description,
    quantity: 120,
    price: Faker::Commerce.price.to_f)
end

12.times do
  Product.create(
    name: Faker::Food.dish,
    category: 'Lanches',
    description: Faker::Food.description,
    quantity: 120,
    price: Faker::Commerce.price.to_f)
end

Product.create([
  {
    name: 'Refrigerante',
    category: 'Bebidas',
    description: 'Coca-cola',
    quantity: 200,
    price: 9.99
  },
  {
    name: 'Suco',
    category: 'Bebidas',
    description: 'suco natural de laranja',
    quantity: 200,
    price: 6.99
  },
  {
    name: 'Milk-shake',
    category: 'Bebidas',
    description: 'milk shake de morango',
    quantity: 200,
    price: 19.99
  }
])

25.times do
  Client.create(
    name: Faker::Name.name,
    email: Faker::Internet.email,
    cpf: Faker::Number.leading_zero_number(digits: 11).to_s
  )
end

client_ids = Client.all.pluck(:id)
products_ids = Product.all.pluck(:id)
3.times do
  cart = Cart.create(
  total_price: 0,
  status: 'Pronto',
  client_id: client_ids.pop
  )

  Faker::Number.between(from: 1, to: 3).times do
    Order.create(product_id: products_ids.pop, quantity: Faker::Number.between(from: 1, to: 5), cart_id: cart.id)
  end
end

3.times do
  cart = Cart.create(
  total_price: 0,
  status: 'Finalizado',
  client_id: client_ids.pop
  )

  Faker::Number.between(from: 1, to: 3).times do
    Order.create(product_id: products_ids.pop, quantity: Faker::Number.between(from: 1, to: 5), cart_id: cart.id)
  end
end


3.times do
  cart = Cart.create(
  total_price: 0,
  status: 'Em_preparação',
  client_id: client_ids.pop
  )

  Faker::Number.between(from: 1, to: 3).times do
    Order.create(product_id: products_ids.pop, quantity: Faker::Number.between(from: 1, to: 5), cart_id: cart.id)
  end
end

3.times do
  cart = Cart.create(
  total_price: 0,
  status: 'Recebido',
  client_id: client_ids.pop
  )

  Faker::Number.between(from: 1, to: 3).times do
    Order.create(product_id: products_ids.pop, quantity: Faker::Number.between(from: 1, to: 5), cart_id: cart.id)
  end
end