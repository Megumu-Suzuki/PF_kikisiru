# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Admin.create!(email: 'admin@gmail.com', password: 'aaaaaa')
User.create!(
  [
    {email: 'test@gmail.com', password: '111111', last_name: '鈴木', first_name: '萌', last_name_kana: 'スズキ', first_name_kana: 'メグム', is_deleted: 'true'},
    {email: 'test1@gmail.com', password: '222222', last_name: 'テスト', first_name: '太郎', last_name_kana: 'テスト', first_name_kana: 'タロウ', is_deleted: 'true'}
  ]
)
genre = Genre.create(name: '冷凍・冷蔵機器')
genre.image.attach(io: File.open(Rails.root.join('db/images/ice-cubes-3506781_640.jpg')), filename: 'ice-cubes-3506781_640.jpg')
genre = Genre.create(name: '加熱機器')
genre.image.attach(io: File.open(Rails.root.join('db/images/burgers-1839090_640.jpg')), filename: 'burgers-1839090_640.jpg')
genre = Genre.create(name: '洗浄機器')
genre.image.attach(io: File.open(Rails.root.join('db/images/dishwasher-1772579_640.jpg')), filename: 'dishwasher-1772579_640.jpg')
genre = Genre.create(name: 'サービス機器')
genre.image.attach(io: File.open(Rails.root.join('db/images/beverage-1840426_640.jpg')), filename: 'beverage-1840426_640.jpg')
genre = Genre.create(name: '製菓・製パン機器')
genre.image.attach(io: File.open(Rails.root.join('db/images/bread-3467243_640.jpg')), filename: 'bread-3467243_640.jpg')
genre = Genre.create(name: '衛生管理機器')
genre.image.attach(io: File.open(Rails.root.join('db/images/eggplant-3587785_640.jpg')), filename: 'eggplant-3587785_640.jpg')
genre = Genre.create(name: 'その他機器')
genre.image.attach(io: File.open(Rails.root.join('db/images/kitchen-1159532_640.jpg')), filename: 'kitchen-1159532_640.jpg')
genre = Genre.create(name: 'その他備品')
genre.image.attach(io: File.open(Rails.root.join('db/images/mixer-tap-413745_640.jpg')), filename: 'mixer-tap-413745_640.jpg')

Tag.create!(
  [
    {name: '便利'},
    {name: '丈夫'},
    {name: '大きい'},
    {name: '小さい'},
    {name: '美味しくなった'},
    {name: '助かる'},
    {name: 'コーヒー'},
    {name: 'ローストビーフ'},
    {name: '焼き鳥'},
    {name: '焼肉'}
  ]
)

