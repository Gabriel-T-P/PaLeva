# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

establishment = Establishment.create!(corporate_name: 'Master LTDA', trade_name: 'Master', full_address: 'Av Teste, 132', cnpj: CNPJ.generate, 
                                      email: 'masterteste123@email.com', phone_number: '1111111111')
master = User.create!(first_name: 'Master', last_name: 'Master', cpf: CPF.generate, email: 'master@email.com', password: '12345678', establishment: establishment)
employee = Employee.create!(first_name: 'Employee', last_name: 'Employee', cpf: CPF.generate, email: 'employee@email.com', password: '12345678', establishment: establishment)

OpeningHour.create!(day_of_week: 0, closed: true, establishment: establishment)
OpeningHour.create!(day_of_week: 1, closed: true, establishment: establishment)
OpeningHour.create!(day_of_week: 2, closed: true, establishment: establishment)
OpeningHour.create!(day_of_week: 3, closed: true, establishment: establishment)
OpeningHour.create!(day_of_week: 4, closed: true, establishment: establishment)
OpeningHour.create!(day_of_week: 5, closed: true, establishment: establishment)
OpeningHour.create!(day_of_week: 6, closed: true, establishment: establishment)

dish1 = Item.create!(name: 'Lasanha', description: 'Alma do macarrão', calories: '350', item_type: 'dish', establishment: establishment)
  portion_dish1_1 = Portion.create!(name: 'Meia Porção', description: 'Lasanha de carne para 1 pessoa', price: 7.50, item: dish1)
  portion_dish1_2 = Portion.create!(name: 'Completo', description: 'Lasanha de carne para 3 pessoa', price: 17.50, item: dish1)
dish2 = Item.create!(name: 'Pizza', description: 'O clássico italiano', calories: '200', item_type: 'dish', establishment: establishment)
  portion_dish2_1 = Portion.create!(name: 'Pequeno', description: '4 pedaços de pizza', price: 15.00, item: dish2)
  portion_dish2_2 = Portion.create!(name: 'Médio', description: '6 pedaços de pizza', price: 20.50, item: dish2)
  portion_dish2_3 = Portion.create!(name: 'Grande', description: '8 pedaços de pizza', price: 25.50, item: dish2)
dish3 = Item.create!(name: 'Espetinho', description: 'A carne mais suculenta', calories: '400', item_type: 'dish', establishment: establishment)
  portion_dish3_1 = Portion.create!(name: '4 pedaços', description: '4 pedaços de carne em cubos', price: 8.00, item: dish3)
  portion_dish3_2 = Portion.create!(name: '6 pedaços', description: '6 pedaços de carne em cubos', price: 12.50, item: dish3)
  portion_dish3_3 = Portion.create!(name: '8 pedaços', description: '8 pedaços de carne em cubos', price: 20.00, item: dish3)

tag1 = Tag.create!(name: 'Picante')
tag2 = Tag.create!(name: 'Bastante Molho')
tag3 = Tag.create!(name: 'Carnes')
tag4 = Tag.create!(name: 'Massa Leve')
ItemTag.create!(item: dish1, tag: tag1)
ItemTag.create!(item: dish1, tag: tag2)
ItemTag.create!(item: dish3, tag: tag3)
ItemTag.create!(item: dish2, tag: tag1)
ItemTag.create!(item: dish2, tag: tag2)
ItemTag.create!(item: dish2, tag: tag4)

beverage1 = Beverage.create!(name: 'Cerveja', description: 'Bebida alcoólica mais comum do Brasil', calories: '100', item_type: 'beverage', establishment: establishment, alcoholic: true)
  portion_beverage1_1 = Portion.create!(name: '200 ml', description: 'Cerveja em um copo de vidro de 200 ml', price: 6.00, item: beverage1)
  portion_beverage1_2 = Portion.create!(name: '600 ml', description: 'Cerveja em um copo de vidro de 600 ml', price: 12.50, item: beverage1)
beverage2 = Beverage.create!(name: 'Suco', description: 'Bebida natural', calories: '65', item_type: 'beverage', establishment: establishment, alcoholic: false)
  portion_beverage2_1 = Portion.create!(name: '200 ml', description: 'Suco em um copo de vidro de 200 ml', price: 8.00, item: beverage2)
  portion_beverage2_2 = Portion.create!(name: '800 ml', description: 'Suco em uma jarra de vidro de 800 ml', price: 16.50, item: beverage2)
beverage3 = Beverage.create!(name: 'Vodka', description: 'Um suco diferente', calories: '80', item_type: 'beverage', establishment: establishment, alcoholic: true)
  portion_beverage3_1 = Portion.create!(name: '200 ml', description: 'Vodka em um copo de vidro de 200 ml', price: 10.00, item: beverage3)
  portion_beverage3_2 = Portion.create!(name: '800 ml', description: 'Vodka em um copo de vidro de 800 ml', price: 18.50, item: beverage3)

tag5 = Tag.create!(name: 'Refrescante')
tag6 = Tag.create!(name: 'Alto Teor Alcoólico')
ItemTag.create!(item: beverage2, tag: tag5)
ItemTag.create!(item: beverage3, tag: tag6)

menu1 = Menu.create!(name: 'Acompanhantes da Noite', establishment: establishment)
  menu1.items<<[beverage1, beverage3]
menu2 = Menu.create!(name: 'Jantar', establishment: establishment)
  menu2.items<<[dish1, dish2, dish3, beverage1, beverage2]

order1 = Order.create!(name: 'Carlos', cpf: CPF.generate, phone_number: '9999-1111', email: 'carlos@email1.com', user: employee)
  PortionOrder.create!(portion: portion_dish1_1, order: order1, quantity: 2, observation: 'Molho Extra')
  PortionOrder.create!(portion: portion_beverage2_1, order: order1, quantity: 1)
order2 = Order.create!(name: 'Juan', cpf: CPF.generate, phone_number: '7777-1111', email: 'juan@email1.com', user: employee)
  PortionOrder.create!(portion: portion_dish2_2, order: order2, quantity: 2)
  PortionOrder.create!(portion: portion_dish3_1, order: order2, quantity: 5)
order3 = Order.create!(name: 'Zigs', cpf: CPF.generate, phone_number: '8888-1111', email: 'zigs@email1.com', user: employee)
  PortionOrder.create!(portion: portion_beverage3_2, order: order3, quantity: 2, observation: 'Sem tomate')
  PortionOrder.create!(portion: portion_dish3_3, order: order3, quantity: 1, observation: 'Bem passada')
  PortionOrder.create!(portion: portion_beverage1_2, order: order3, quantity: 1, observation: 'Com gelo')
order4 = Order.create!(name: 'Karl', cpf: CPF.generate, phone_number: '4444-1111', email: 'karl@email1.com', user: employee)
order4.update(status: 'canceled')
