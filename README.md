# mecopy_slack
## DB　(edited: 2018/12/23)
### channels table

| Column   | Type     | Options  |
| -------- | -------- | -------- |
| name   | string   | unique:true, null: false          |
| is_privated   | boolean    | default: false, null: false          |
| is_archived   | boolean    | default: false, null: false          |

#### Association
has_many: users, through: :groups_users
has_many: groups_users
has_many: messages


### users table

| Column   | Type     | Options  |
| -------- | -------- | -------- |
| name     | String   |  unique:true, null: false    |
| show_name | string   |  |
| role | String    |          |
| phone | string |  |
| skype | string  |  |

#### Associaltion
has_many: users, through: :groups_users
has_many: groups_users
has_many: messages

### messages table
| Column   | Type     | Options  |
| -------- | -------- | -------- |
| content     | text     | |
| image    | string   | |
| user_id  | integer  | foreign_key: true|
| channel_id  | integer  | foreign_key: true|
| *is_pinned* | boolean  | |

#### Associaltion
belongs_to :user
belongs_to :channel


## TODO
- [ ] viewの作成
- [ ] deviseの導入
- [ ] メッセージ機能の作成
- [ ] ユーザープロフィールの追加
- [ ] 画像投稿機能作成
- [ ] ファイル投稿機能の追加
- [ ] Pin機能追加
- [ ] 右サイドバー作成