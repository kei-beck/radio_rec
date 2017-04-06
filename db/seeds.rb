# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Station.create(radiru_station_id: "r1",
               name:              "NHK1",
               ascii_name:        "NHK1")
Station.create(radiru_station_id: "r2",
               name:              "NHK2",
               ascii_name:        "NHK2")
Station.create(radiru_station_id: "fm",
               name:              "NHKFM",
               ascii_name:        "NHKFM")
Keyword.create(keyword:         "バナナマン",
               title_flg:       true,
               sub_title_flg:   false,
               performer_flg:   true,
               description_flg: false,
               information_flg: false,
               twitter_flg:     false)
Keyword.create(keyword:         "伊集院光",
               title_flg:       false,
               sub_title_flg:   false,
               performer_flg:   true,
               description_flg: false,
               information_flg: false,
               twitter_flg:     false)
Keyword.create(keyword:         "深夜の馬鹿力",
               title_flg:       true,
               sub_title_flg:   false,
               performer_flg:   false,
               description_flg: false,
               information_flg: false,
               twitter_flg:     false)
Keyword.create(keyword:         "乃木坂",
               title_flg:       true,
               sub_title_flg:   true,
               performer_flg:   true,
               description_flg: true,
               information_flg: true,
               twitter_flg:     true)
Keyword.create(keyword:         "欅坂",
               title_flg:       true,
               sub_title_flg:   true,
               performer_flg:   true,
               description_flg: true,
               information_flg: true,
               twitter_flg:     true)
Keyword.create(keyword:         "らじらー！　サンデー",
               title_flg:       true,
               sub_title_flg:   false,
               performer_flg:   false,
               description_flg: false,
               information_flg: false,
               twitter_flg:     false)
Keyword.create(keyword:         "ももクロくらぶ",
               title_flg:       true,
               sub_title_flg:   false,
               performer_flg:   false,
               description_flg: false,
               information_flg: false,
               twitter_flg:     false)
