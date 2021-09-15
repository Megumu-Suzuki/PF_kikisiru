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
Genre.create!(
  [
    {name: '冷凍・冷蔵機器'},
    {name: '加熱機器'},
    {name: '洗浄機器'},
    {name: 'サービス用機器'},
    {name: '製菓・製パン機器'},
    {name: '作業機器'},
    {name: 'その他機器'},
    {name: 'その他備品'}
  ]
)

