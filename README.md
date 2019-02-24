# README

* Database creation

## usersテーブル

|Column|Type|Options|
|------|----|-------|
|nickname|string|null: false|
|last_name|string|null: false|
|first_name|string|null: false|
|last_name_kana|string|null: false|
|first_name_kana|string|null: false|
|date_of_birth|string|null: false|
|zip_code|integer||
|region|string||
|city|string||
|adress_line1|string||
|adress_line2|string||
|phone_number|string||
|mail_adress|string|null: false|
|password|string|null: false|
|password_confirmation|string|null: false|
|credit_card_number|integer||
|introduction|text||
|profile_image|string||

### Association
- has_many :user_rating
- has_many :orders
- has_many :flags
- has_many :likes
- has_many :comments
- has_many :buyed_products, foreign_key: "buyer_id", class_name: "Product"
- has_many :selling_items, -> { where("buyer_id is NULL") }, foreign_key: "seller_id", class_name: "Product"
- has_many :sold_items, -> { where("buyer_id is not NULL") }, foreign_key: "seller_id", class_name: "Product"
- has_many :liked_products, through: :likes, source: :product
- has_many :flag_products, through: :flags, source: :product

## user_ratingsテーブル

|Column|Type|Options|
|------|----|-------|
|seller_id|references|foreign_key: true|
|buyer_id|references|foreign_key: true|
|rating|integer|null: false|

### Association
- belongs_to :users

## productsテーブル

|Column|Type|Options|
|------|----|-------|
|name|string|null: false|
|product_description|text|null: false|
|category1|string|null: false|
|category2|string|null: false|
|category3|string|null: false|
|brand|string|null: false|
|size|string|null: false|
|region|string|null: false|
|postage|string|null: false|
|ship_from|string|null: false|
|shipping_date|string|null: false|
|price|integer|null: false|
|point|integer||
|on_display|string||
|during_trading|string||
|sold_out|string||
|seller_id|string|null: false|
|buyer_id|string||

### Association
- belongs_to :user
- belongs_to :seller, class_name: "User"
- belongs_to :buyer, class_name: "User"
- has_many :product_images
- belongs_to :order
- has_many :flags
- has_many :likes
- has_many :comments
- has_many :liked_users, through: :likes, source: :user
- has_many :flag_users, through: :flags, source: :user

## product_imagesテーブル

|Column|Type|Options|
|------|----|-------|
|product_id|references|foreign_key: true|
|product_image|string|null: false|

### Association
- belongs_to :product

## ordersテーブル

|Column|Type|Options|
|------|----|-------|
|seller_id|references|foreign_key: true|
|buyer_id|references|foreign_key: true|
|product_id|references|foreign_key: true|
|datatime|datetime|null: false|

### Association
- has_many :users, through: :members
- has_many :messages

## flagsテーブル

|Column|Type|Options|
|------|----|-------|
|user_id|references|foreign_key: true|
|product_id|references|foreign_key: true|

### Association
- belongs_to :user
- belongs_to :product
- validates_uniquess_of :product_id, scope: :user_id

## likesテーブル

|Column|Type|Options|
|------|----|-------|
|user_id|references|foreign_key: true|
|product_id|references|foreign_key: true|

### Association
- belongs_to :user
- belongs_to :product
- validates_uniquess_of :product_id, scope: :user_id

## commentsテーブル

|Column|Type|Options|
|------|----|-------|
|user_id|references|foreign_key: true|
|product_id|references|foreign_key: true|
|comment|text|null: false|

### Association
- belongs_to :user
- belongs_to :product
