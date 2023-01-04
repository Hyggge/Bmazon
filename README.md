# rails 后端设计文档

## 一、数据模型文档

#### 用户（User）

| 列名            | 类型      | 约束                                 | 描述                    |
| --------------- | --------- | ------------------------------------ | ----------------------- |
| id              | INT       | 非空，主键                           | 唯一标识                |
| username        | VARCHAR   | 非空，唯一                           | 用户名，用户登录        |
| password_digest | CHAR(128) | 非空                                 | 密码（JWT加密后的密文） |
| email           | VARCHAR   | 非空                                 | 电子邮箱                |
| phone_no        | VARCHAR   |                                      | 电话                    |
| signature       | VARCHAR   |                                      | 个性签名                |
| role            | INT       | 非空，枚举值：管理员(0)、普通用户(1) | 角色                    |
| image_id        | INT       |                                      | 用户头像                |

#### 学生认证（Student）

| 列名            | 类型    | 约束                            | 描述     |
| --------------- | ------- | ------------------------------- | -------- |
| id              | INT     | 非空,主键                       | 唯一标识 |
| name            | VARCHAR | 非空                            | 学生姓名 |
| depart          | INT     | 非空,枚举量: 北航所有院系的系号 | 所属院系 |
| attendance_year | INT     | 非空                            | 入学年份 |
| gender          | INT     | 非空,枚举量: 男(0)、女(1)       | 性别     |
| image_id        | INT     | 非空,学生证图片                 |          |
| user_id         | INT     | 非空, 对应用户id                | 性别     |

#### 店铺（shop）

| 列名         | 类型    | 约束                                  | 描述       |
| ------------ | ------- | ------------------------------------- | ---------- |
| id           | INT     | 非空,主键                             | 唯一标识   |
| name         | VARCHAR | 非空                                  | 店铺名     |
| introduction | TEXT    |                                       | 店铺介绍   |
| type         | INT     | 非空,枚举量: 个人店铺(0)、合作店铺(1) | 店铺类型   |
| image_id     | INT     |                                       | 店铺头像   |
| owner_id     | INT     | 非空,外键: User.id                    | 店铺拥有者 |

#### 店铺-管理员表（shopManagement）

| 列名    | 类型 | 约束               | 描述     |
| ------- | ---- | ------------------ | -------- |
| id      | INT  | 非空,主键          | 唯一标识 |
| shop_id | INT  | 非空,外键: Shop.id | 店铺id   |
| user_id | INT  | 非空,外键: User.id | 管理者id |

> 这里的店铺指的是合作店铺，并且店主不属于管理员

#### 商品（commodity）

| 列名         | 类型         | 约束                                                    | 描述             |
| ------------ | ------------ | ------------------------------------------------------- | ---------------- |
| id           | BNT          | 非空,主键                                               | 唯一标识         |
| name         | VARCHAR      | 非空                                                    | 商品名称         |
| introduction | TEXT         |                                                         | 商品介绍         |
| status       | INT          | 非空,枚举量: 未生效(0)、预售中(1)、售卖中(2)、已下架(3) | 商品状态         |
| total        | INT          | 非空                                                    | 商品总量         |
| sale         | INT          | 非空                                                    | 已销售量         |
| price        | DECIMAL(8,2) | 非空                                                    | 商品基础价格     |
| method       | INT          | 非空,枚举量: 线上交易(0)、线下自取(1)、送货上门(2)      | 交易方式         |
| shop_id      | INT          | 非空 Shop.id                                            | 所属店铺         |
| image_id     | INT          | File.id                                                 | 搜索显示的缩略图 |

#### 评论（comment）

| 列名     | 类型 | 约束                                                         | 描述       |
| -------- | ---- | ------------------------------------------------------------ | ---------- |
| id       | INT  | 非空,主键                                                    | 唯一标识   |
| grade    | INT  | 非空,枚举量: 非常差(1)、较差(2)、中等(3)、较好(4)、非常好(5) | 评价星级   |
| content  | TEXT | 非空                                                         | 评价内容   |
| order_id | NT   | 非空,外键: Order.id                                          | 关联订单id |

#### 订单（order）

| 列名         | 类型         | 约束                                                         | 描述         |
| ------------ | ------------ | ------------------------------------------------------------ | ------------ |
| id           | INT          | 非空,主键                                                    | 唯一标识     |
| status       | INT          | 非空,枚举量: 已下单(0)、已支付(1)、已送达(2)、已确认(3)、已评价(4)、已关闭(5) | 订单状态     |
| price        | DECIMAL(8,2) | 非空                                                         | 订购商品单价 |
| num          | INT          | 非空                                                         | 订购商品数量 |
| address      | VARCHAR      |                                                              | 收/取货地址  |
| note         | TEXT         |                                                              | 备注         |
| pay_time     | DATETIME(6)  |                                                              | 付款时间     |
| confirm_time | DATETIME(6)  |                                                              | 确认时间     |
| close_time   | DATETIME(6)  |                                                              | 关闭时间     |
| deliver_time | DATETIME(6)  |                                                              | 发货时间     |
| commodity_id | INT          | 非空,外键: Commodity.id                                      | 购买商品id   |
| user_id      | INT          | 非空,外键: User.id                                           | 购物用户id   |

#### 收藏（collect）

| 列名         | 类型   | 约束                    | 描述     |
| ------------ | ------ | ----------------------- | -------- |
| id           | BIGINT | 非空,主键               | 唯一标识 |
| commodity_id | INT    | 非空,外键: Commodity.id | 商品id   |
| user_id      | INR    | 非空,外键: User.id      | 用户id   |

#### 商品参数（param）

| 列名         | 类型        | 约束      | 描述       |
| ------------ | ----------- | --------- | ---------- |
| id           | BIGINT      | 非空,主键 | 唯一标识   |
| name         | VARCHAR(50) | 非空      | 参数名     |
| commodity_id | BIGINT      | 非空      | 关联商品id |

#### 商品参数选项 （option）

| 列名        | 类型         | 约束               | 描述         |
| ----------- | ------------ | ------------------ | ------------ |
| id          | INT          | 非空,主键          | 唯一标识     |
| description | VARCHAR      | 非空               | 参数选项描述 |
| add         | DECIMAL(8,2) | 非空               | 选项附加价格 |
| param_id    | INT          | 非空,外键: Para.id | 所属参数     |

#### 订单-选项表（OrderOptionMap）

| 列名      | 类型 | 约束                 | 描述       |
| --------- | ---- | -------------------- | ---------- |
| id        | INT  | 非空,主键            | 唯一标识   |
| order_id  | INT  | 非空,外键: Order.id  | 订单id     |
| option_id | INT  | 非空,外键: Option.id | 参数选项id |

#### 文章（Article）

| 列名         | 类型        | 约束                | 描述       |
| ------------ | ----------- | ------------------- | ---------- |
| id           | INT         | 非空,主键           | 唯一标识   |
| title        | VARCHAR     | 非空                | 文章标题   |
| content      | TEXT        | 非空                | 文章内容   |
| post_time    | DATETIME(6) | 非空                | 发布时间   |
| commodity_id | INT         | 外键: Commodity.id  | 关联商品id |
| author_id    | INT         | 非空，外键: User.id | 发布用户id |

#### 文章回复（reply）

| 列名       | 类型 | 约束                  | 描述         |
| ---------- | ---- | --------------------- | ------------ |
| id         | INT  | 非空,主键             | 唯一标识     |
| floor      | INT  | 非空                  | 回复所在楼层 |
| content    | TEXT | 非空                  | 回复内容     |
| article_id | INT  | 非空,外键: Article.id | 回复所在文章 |
| refer_id   | INT  | 外键: Reply.id        | 引用的回复   |
| user_id    | INT  | 非空,外键: User.id    | 回复发布者   |

#### 图片（image）

| 列名 | 类型 | 约束      | 描述          |
| ---- | ---- | --------- | ------------- |
| id   | INT  | 非空,主键 | 唯一标识      |
| url  | INT  | 非空      | 图片对应的url |





## 二、API文档

### (1) 登录注册相关API

#### 1. 登录

##### `[POST] /api/auth/login`

##### Body

* 必要字段：`username, passowrd`

  ```json
  {
      "username": "czh",
      "password": "123456"
  }
  ```

##### Response

* 成功则返回：``id`（用户id）`token`（JWT token）, `ddl`（token有效截止时间），`role`（0表示管理员，1表示非管理员）

  ```json
  {
      "id": 1,
  	"token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE2NzI4MTg3MDd9.SCkAmwUYgQYTuTg8oN0XOavRTIMYK8F7p6ha_gJwvDo",
  	"ddl": "01-04-2023 15:51",
  	"role": 0
  }
  ```



#### 2. 注册

##### `[POST] /api/auth/register`

##### Body

* 必要字段：`username, passowrd, email`

* 可选字段：`signature, phone_no`

  ```json
  {
      "username": "mlh",
      "password": "123456",
      "email": "mlhsdmv@qq.com",
  }
  ```

##### Response

* 成功则返回提示信息和用户`id`

  ```json
  {
  	"success": true,
  	"id": 3
  }
  ```

* 如果用户名已存在，会返回错误信息（由rails自动生成）

  ```json
  {
  	"error": {
  		"username": [
  			"has already been taken"
  		]
  	}
  }
  ```



#### 3. 检查用户名是否存在

##### `[GET] /api/auth/check_dup_username/<str:username>`

##### Param

* username 为要检查的用户名

##### Response

* 响应内容：exist 表示用户名是否存在

  ```json
  {
  	"exist": true
  }
  ```



### (2) 用户相关API

#### 1. 获取用户详情信息

##### `[GET] /api/users/<int:user_id>`

##### Param

- user_id 为要查询用户的 id

##### Response

- 响应内容包括：`id, username, reg_time, phone_no, email, signature, role, status, student_info, img_url` 其中 `img_url` 为头像的下载链接

    - status表示用户是否学生认证：1表示已认证，0表示未认证
    - student_info是一个哈希，当且仅当status == 1(已经认证)的时候才不为null。student_info的信息包括——`id, name, gender, depart, attendance_year, `

  ```json
  {
  	"id": 1,
  	"username": "czh",
  	"reg_time": "2023-01-02T00:00:31.574+08:00",
  	"phone_no": null,
  	"email": "13181396138@qq.com",
  	"signature": "哥就是一个传说",
  	"role": 0,
  	"status": 1,
  	"student_info": {
  		"id": 20373379,
  		"name": "陈正昊",
          "gender": 0,
  		"depart": 6,
  		"attendance_year": 2022
  	},
  	"image_url": "http://localhost:3000/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBDQT09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--9678a3a147122250f7701fb1b2dfb5d6e4be52e6/head.jpg"
  }
  ```



#### 2. 修改用户信息

##### `[PUT] /api/users/<int:user_id>`

##### Param

- user_id 为用户 id

##### Body

- 可选字段：` phone_no, email, signature`

  ```json
  {
      "phone_no": "13181396138",
      "email": "hyggge6@gmail.com",
      "signature": "nothing is impossible"
  }
  ```

##### Response

- 成功返回提示信息

  ```
  {
  	"success": true
  }
  ```



#### 3. 管理员获取用户列表

##### `[GET] /api/admin/users`

##### Query

- 必要参数：page
- 可选参数：page_size（默认为10）

##### Response

- 成功则返回下面的内容，包括：总数量`tot_count`，总页数`page_all`， 当前页号`page`， 用户列表`data`

  ```json
  {
  	"tot_count": 2,
  	"page_all": 1,
  	"page": 1,
  	"data": [
  		{
  			"id": 1,
  			"username": "czh",
  			"email": "hyggge6@gmail.com",
  			"reg_time": "2023-01-02T00:00:31.574+08:00",
  			"phone_no": "13181396138",
  			"signature": "nothing is impossible",
  			"role": 0
  		},
  		{
  			"id": 2,
  			"username": "mlh",
  			"email": "mlhsdmv@qq.com",
  			"reg_time": "2023-01-02T15:07:13.923+08:00",
  			"phone_no": null,
  			"signature": null,
  			"role": 0
  		}
  	]
  }
  ```



### (3) 学生相关API

#### 1. 学生认证

##### `[POST] /api/students`

##### Body

- 必要字段：`student_id, student_name, depart, attendance_year, gender, image_id`

  ```json
  {
      "student_id": 20373379,
      "student_name": "陈正昊",
      "depart": 6,
      "attendance_year": 2022,
      "gender": 0,
      "image_id": 1
  }
  ```

##### Response

- 成功则返回提示信息和学生id

  ```
  {
  	"success": true,
  	"id": 20373379
  }
  ```

- 如果学号被认证过，则返回错误信息

  ```json
  {
  	"error": "the student id has been authenticated"
  }
  ```



#### 2. 检查学号是否已经认证过

##### `[GET] /api/students/:student_id/check_dup_student_id`

##### Param

- student_id 为要检查的学号

##### Response

- 返回字段：exist表示学号是否被认证过

  ```json
  {
  	"exist": true
  }
  ```



#### 3. 管理员获取全部学生认证信息

##### `[GET] /api/admin/students`

##### Query

- 必要参数：page
- 可选参数：page_size（默认为10）

##### Response

- 成功则返回下面的内容，包括：总数量`tot_count`，总页数`page_all`， 当前页号`page`， 学生认证列表`data`

```json
{
	"tot_count": 2,
	"page_all": 1,
	"page": 1,
	"data": [
		{
			"user_id": 2,
			"username": "mlh",
			"student_id": 20373311,
			"student_name": "闵令杭",
			"req_time": "2023-01-02T15:13:24.914+08:00"
		},
		{
			"user_id": 1,
			"username": "czh",
			"student_id": 20373379,
			"student_name": "陈正昊",
			"req_time": "2023-01-03T17:01:57.660+08:00"
		}
	]
}
```



### (4) 店铺相关API

#### 1. 创建新店铺

##### `[POST] /api/shops`

##### Body

* 必要字段：`name`（店铺名称）, `introduction`（店铺介绍）, `type`（0表示个人店铺，1表示合作店铺）

  ```json
  {
      "name": "昊昊的小吃铺",
      "introduction": "好吃不贵，量大优惠",
      "type": 1
  }
  ```

##### Response

* 成功则返回提示信息和店铺 id

  ```json
  {
  	"success": true,
  	"id": 2
  }
  ```

* 开店需要先学生认证，否则会返回错误信息

> 创建出来的店铺属于当前登录的用户



#### 2. 合作店铺增加管理员

##### `[POST] /api/shops/<int:shop_id>/managers`

##### Param

- shop_id 为对应的店铺 id

##### Body

* 必要字段：student_id

  ```json
  {
      "student_id": 20373311
  }
  ```

##### Response

* 成功返回提示信息

  ```json
  {
  	"success": true
  }
  ```

* 如果当前用户为不是店主（管理员不能加管理员，只有店主能加）， 或者店铺类型不为合作店铺，则返回错误信息



#### 3. 合作店铺删除管理员

##### `[DELETE] /api/shops/<int:shop_id>/managers/<int:student_id>`

##### Param

- shop_id 为对应店铺 id
- student_id 为管理员的学号

##### Response

* 成功返回提示信息

  ```json
  {
  	"success": true
  }
  ```

* 如果当前用户为不是店主（管理员不能删除管理员，只有店主能删）， 或者店铺类型不为合作店铺，则返回错误信息



#### 4. 获取店铺详情

##### `[GET] /api/shops/<int:shop_id>`

##### Param

- shop_id 为店铺 id

##### Response

* 成功则返回下面的内容，包括 `id, name, reg_time, introduction, type, grade, img_url, owner_info, managers`

    - 其中 type 为0表示个人店铺，为1表示合作店铺
    - 对于任何店铺，都显示店主本人的学生信息。student_info是一个哈希，包含 `id, username, student_id, real_name`
    - 对于合作店铺，显示管理员信息。managers是一个列表，每一列表都是一个管理员的具体信息——`username, student_id, real_name`

  ```json
  {
  	"id": 2,
  	"name": "昊昊的小吃铺",
  	"reg_time": "2023-01-03T17:18:22.874+08:00",
  	"introduction": "好吃不贵，量大优惠",
  	"type": 1,
  	"grade": null,
  	"image_url": null,
  	"owner_info": {
  		"id": 1,
  		"username": "czh",
  		"student_id": 20373379,
  		"real_name": "陈正昊"
  	},
  	"managers": [
  		{
  			"username": "mlh",
  			"student_id": 20373311,
  			"real_name": "闵令杭"
  		}
  	]
  }
  ```



#### 5. 获取用户名下所有店铺

##### `[GET] /api/users/<int:user_id>/shops`

##### Param

- user_id 为用户 id

##### Response


* 成功则返回下面的内容，包含 `owning_shop, managing_shop`，分别是"拥有的店铺列表"和"管理的店铺列表"，两者交集为空。列表中每个元素都是一个哈希，包含 `id, name, reg_time, type`

  ```json
  {
  	"owning_shops": [
  		{
  			"id": 1,
  			"name": "czh的小店",
  			"reg_time": "2023-01-02T15:05:12.203+08:00",
  			"type": 1
  		},
  		{
  			"id": 2,
  			"name": "昊昊的小吃铺",
  			"reg_time": "2023-01-03T17:18:22.874+08:00",
  			"type": 1
  		}
  	],
  	"managing_shops": [
  		{
  			"id": 3,
  			"name": "杭杭的美妆店",
  			"reg_time": "2023-01-03T18:06:25.518+08:00",
  			"type": 1
  		}
  	]
  }
  ```



#### 6. 管理员获取店铺列表

##### `[GET] /api/admin/shops`

##### Query

- 必要参数 page
- 可选参数：page_size（默认为10）

##### Response

- 成功则返回下面的内容，包括：总数量`tot_count`，总页数`page_all`， 当前页号`page`， 店铺列表`data`

```json
{
	"tot_count": 3,
	"page_all": 1,
	"page": 1,
	"data": [
		{
			"id": 1,
			"name": "czh的小店",
			"type": 1,
			"reg_time": "2023-01-02T15:05:12.203+08:00",
			"owner_info": {
				"user_id": 1,
				"student_id": 20373379,
				"student_name": "陈正昊"
			}
		},
		{
			"id": 2,
			"name": "昊昊的小吃铺",
			"type": 1,
			"reg_time": "2023-01-03T17:18:22.874+08:00",
			"owner_info": {
				"user_id": 1,
				"student_id": 20373379,
				"student_name": "陈正昊"
			}
		},
		{
			"id": 3,
			"name": "杭杭的美妆店",
			"type": 1,
			"reg_time": "2023-01-03T18:06:25.518+08:00",
			"owner_info": {
				"user_id": 2,
				"student_id": 20373311,
				"student_name": "闵令杭"
			}
		}
	]
}
```





### （5）商品相关API

#### 1. 增加商品

##### `[POST] /api/shops/<int:shop_id>/commodities`

##### Param

- shop_id 对对应店铺 id

##### Body

- 必要字段 `name, total, price, status, method, image_id`

- 可选字段 `introduction, params`, params表示和该商品关联的参数信息

  ```json
  {
      "name": "羊肉串",
      "total": 1000,
      "price": 3.00,
      "status": 0,
      "method" : 1,
      "introduction": "yyds",
      "image_id": 1,
      "params": [
          {
              "name": "羊的品种",
              "options": [
                  {"description": "山羊", "add": 1.50},
                  {"description": "绵羊", "add": 2.00}
              ]
          },
          {
              "name": "产地",
              "options": [
                  {"description": "北方", "add": 0.00},
                  {"description": "南方", "add": 0.50}
              ]
          }
      ]
  }
  
  ```

##### Response

- 成功则返回提示信息和商品id

  ```json
  {
  	"success": true,
  	"id": 4
  }
  ```

- 如果用户不为店主或店铺管理员，则返回错误信息



#### 2. 删除商品

##### `[DELETE] /api/commodities/<int:commodity_id>`

##### Param

- commodity_id 为商品id

##### Response

- 成功则返回提示信息

  ```json
  {
  	"success": true,
  	"id": 4
  }
  ```

- 需要用户为店主或店铺管理员，否则返回错误

- 需要该商品没有与之关联的订单，否则返回错误



#### 3. 获取商品详情

##### `[GET] /api/commodities/<int:commodity_id>`

##### Param

- commodity_id 为商品 id

##### Response

- 包含字段：`id, name, introduction, status, total, sale, price, img_url, shop_info, params,`

    - shop_info 包括所在店铺的`id、name、type, introduction`
    - params是和商品相关的参数列表

  ```json
  {
  	"id": 1,
  	"name": "汽水",
  	"introduction": "快乐水yyds",
  	"status": 0,
  	"total": 100,
  	"sale": 1,
  	"price": "10.0",
  	"image_url": "http://localhost:3000/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBCZz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--f9be98befd8ef27ad3c8bb33f7f57380aabd2200/%E5%BD%95%E5%8F%96%E9%80%9A%E7%9F%A5%E4%B9%A6.jpg",
  	"shop_info": {
  		"id": 1,
  		"name": "czh的小店",
  		"type": 1,
  		"introduction": "机不可失！！！"
  	},
  	"params": [
  		{
  			"name": "品种",
  			"options": [
  				{
  					"description": "雪碧",
  					"add": 1
  				},
  				{
  					"description": "芬达",
  					"add": 2
  				}
  			]
  		},
  		{
  			"name": "产地",
  			"options": [
  				{
  					"description": "北京",
  					"add": 1
  				},
  				{
  					"description": "天津",
  					"add": 1.5
  				}
  			]
  		}
  	]
  }
  ```



#### 4. 更新商品详情

##### `[PUT] /api/commodities/<int:commodity_id>`

##### Param

- commodity_id 为商品 id

##### Body

- 必要字段 `status`（商品状态：未生效(0)、预售中(1)、售卖中(2)、已下架(3)）

  ```json
  {
      "status": 1
  }
  ```

##### Response

- 成功则返回提示信息

  ```json
  {
  	"success": true
  }
  ```

- 如果用户不是店主或店铺管理员，则返回错误信息



#### 5. 用户查找所有商品

##### `[GET] /api/commodities`

##### Query

- 必要参数：page
- 可选参数：page_size（默认为12）
- 必要字段：keyword

##### Response

- 成功则返回下面的内容，包括：总数量`tot_count`，总页数`page_all`， 当前页号`page`， 商品列表`data`

  ```json
  {
  	"tot_count": 2,
  	"page_all": 1,
  	"page": 1,
  	"data": [
  		{
  			"id": 1,
  			"name": "汽水",
  			"introduction": "快乐水yyds",
  			"status": 1,
  			"total": 100,
  			"sale": 1,
  			"price": "10.0",
  			"grade": 5,
  			"image_url": "http://localhost:3000/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBCZz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--f9be98befd8ef27ad3c8bb33f7f57380aabd2200/%E5%BD%95%E5%8F%96%E9%80%9A%E7%9F%A5%E4%B9%A6.jpg",
  			"shop_info": {
  				"id": 1,
  				"name": "czh的小店"
  			}
  		},
  		{
  			"id": 4,
  			"name": "羊肉串",
  			"introduction": "yyds",
  			"status": 0,
  			"total": 1000,
  			"sale": 0,
  			"price": "3.0",
  			"grade": null,
  			"image_url": "http://localhost:3000/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBCZz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--f9be98befd8ef27ad3c8bb33f7f57380aabd2200/%E5%BD%95%E5%8F%96%E9%80%9A%E7%9F%A5%E4%B9%A6.jpg",
  			"shop_info": {
  				"id": 1,
  				"name": "czh的小店"
  			}
  		}
  	]
  }
  ```



#### 6. 店铺所有商品

##### `[GET] /api/shops/<int:shop_id>/commodities`

##### Param

- shop_id 为店铺 id

##### Query

- 必要参数：page
- 可选参数：page_size（默认为10）
- 必要字段：keyword

##### Response

- 成功则返回下面的内容，包括：总数量`tot_count`，总页数`page_all`， 当前页号`page`， 商品列表`data`

  ```json
  {
  	"tot_count": 2,
  	"page_all": 1,
  	"page": 1,
  	"data": [
  		{
  			"id": 1,
  			"name": "汽水",
  			"introduction": "快乐水yyds",
  			"status": 1,
  			"total": 100,
  			"sale": 1,
  			"price": "10.0",
  			"grade": 5,
  			"image_url": "http://localhost:3000/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBCZz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--f9be98befd8ef27ad3c8bb33f7f57380aabd2200/%E5%BD%95%E5%8F%96%E9%80%9A%E7%9F%A5%E4%B9%A6.jpg"
  		},
  		{
  			"id": 4,
  			"name": "羊肉串",
  			"introduction": "yyds",
  			"status": 0,
  			"total": 1000,
  			"sale": 0,
  			"price": "3.0",
  			"grade": null,
  			"image_url": "http://localhost:3000/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBCZz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--f9be98befd8ef27ad3c8bb33f7f57380aabd2200/%E5%BD%95%E5%8F%96%E9%80%9A%E7%9F%A5%E4%B9%A6.jpg"
  		}
  	]
  }
  ```



#### 7. 管理员查看所有商品

##### `[GET] /api/admin/commodities`

##### Param

- 必要参数：page
- 可选参数：page_size（默认为10）

##### Response

- 成功则返回下面的内容，包括：总数量`tot_count`，总页数`page_all`， 当前页号`page`， 商品列表`data`

  ```json
  {
  	"tot_count": 2,
  	"page_all": 1,
  	"page": 1,
  	"data": [
  		{
  			"id": 1,
  			"name": "汽水",
  			"introduction": "快乐水yyds",
  			"status": 1,
  			"total": 100,
  			"sale": 1,
  			"price": "10.0",
  			"grade": 5,
  			"image_url": "http://localhost:3000/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBCZz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--f9be98befd8ef27ad3c8bb33f7f57380aabd2200/%E5%BD%95%E5%8F%96%E9%80%9A%E7%9F%A5%E4%B9%A6.jpg",
  			"shop_info": {
  				"id": 1,
  				"name": "czh的小店"
  			}
  		},
  		{
  			"id": 4,
  			"name": "羊肉串",
  			"introduction": "yyds",
  			"status": 0,
  			"total": 1000,
  			"sale": 0,
  			"price": "3.0",
  			"grade": null,
  			"image_url": "http://localhost:3000/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBCZz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--f9be98befd8ef27ad3c8bb33f7f57380aabd2200/%E5%BD%95%E5%8F%96%E9%80%9A%E7%9F%A5%E4%B9%A6.jpg",
  			"shop_info": {
  				"id": 1,
  				"name": "czh的小店"
  			}
  		}
  	]
  }
  ```





#### 8. 用户收藏商品

##### `[POST] /api/commodities/<int:commodity_id>/collect`

##### Param

- commodity_id 为商品 id

##### Response

- 成功则返回提示信息

  ```json
  {
  	"success": true
  }
  ```

- 如果当前用户已经收藏过该商品，则返回错误信息



#### 9. 用户取消收藏商品

##### `[POST] /api/commodities/<int:commodity_id>/cancel_collect`

##### Param

- commodity_id 为商品 id

##### request

- 成功则返回提示信息

  ```json
  {
  	"success": true
  }
  ```

- 如果当前用户没有收藏过该商品，则返回错误信息



#### 10. 用户查看自己的收藏列表

##### `[GET] /api/commodities/collect/list`

##### Param

- 必要参数：page
- 可选参数：page_size（默认为10）

##### Response

- 成功则返回下面的内容，包括：总数量`tot_count`，总页数`page_all`， 当前页号`page`， 商品列表`data`

  ```json
  {
  	"tot_count": 1,
  	"page_all": 1,
  	"page": 1,
  	"data": [
  		{
  			"id": 1,
  			"name": "汽水",
  			"introduction": "快乐水yyds",
  			"status": 1,
  			"total": 100,
  			"sale": 1,
  			"price": "10.0",
  			"grade": 5,
  			"image_url": "http://localhost:3000/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBCZz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--f9be98befd8ef27ad3c8bb33f7f57380aabd2200/%E5%BD%95%E5%8F%96%E9%80%9A%E7%9F%A5%E4%B9%A6.jpg",
  			"shop_info": {
  				"id": 1,
  				"name": "czh的小店"
  			}
  		}
  	]
  }
  ```



### （6）订单相关API

#### 1. 下单

##### `[POST] /api/orders`

##### Body

- 必要字段：`commodity_id`（商品id）, `num`（商品数量）, `selected_options`（所选option的id的列表，可为空）

- 可选字段：`address`（收货地址）, `note`（备注）

  ```json
  {
      "commodity_id": 1,
      "num": 1,
      "selected_options": [
          5,
          12
      ],
      "address": "校内五公寓522",
      "note": "一天之内发货不然不要了"
  }
  ```

##### Response

- 成功则返回提示信息

  ```json
  {
  	"success": true
  }
  ```

- 如果库存不足，则返回错误信息



#### 2. 获取订单详情

##### `[GET] /api/orders/<int:order_id>`

##### Param

- order_id 为订单 id

##### Response

- 成功则返回下面的内容，包括`id, num, price, address, note, status, start_time, pay_time, deliver_time, confirm_time, close_time, selected_options, user_info, commodity_info`
    - selected_options是一个列表，包含该订单中用户选择的各个参数选项
    - user_info是存储用户信息的哈希，包括`id, username`
    - commodity_info是存储对应商品信息的哈希，包括`id, name, price, shop_id, shop_name`

```json
{
	"id": 1,
	"num": 1,
	"price": "12.0",
	"address": "校内五公寓522",
	"note": "一天之内发货不然不要了",
	"status": 4,
	"start_time": "2023-01-03T00:53:04.534+08:00",
	"pay_time": "2023-01-03T00:55:33.253+08:00",
	"deliver_time": "2023-01-03T00:55:54.940+08:00",
	"confirm_time": "2023-01-03T00:56:08.875+08:00",
	"close_time": null,
	"selected_options": [
		{
			"id": 1,
			"description": "雪碧",
			"add": 1
		},
		{
			"id": 3,
			"description": "北京",
			"add": 1
		}
	],
	"user_info": {
		"id": 1,
		"username": "czh"
	},
	"commodity_info": {
		"id": 1,
		"name": "汽水",
		"price": "10.0",
        "imgae_url": "....",
		"shop_id": 1,
		"shop_name": "czh的小店"
	}
}
```

#### 3. 关闭订单

##### `[POST] /api/orders/<int:order_id>/close`

##### Param

- order_id 为订单 id

##### Body

- 成功则返回提示信息

  ```json
  {
  	"success": true
  }
  ```

- 如果当前用户不是订单的发起者，则返回错误信息



#### 4. 支付订单

##### `[POST] /api/orders/<int:order_id>/pay`

##### Param

- order_id 为订单 id

##### Body

- 成功则返回提示信息

  ```json
  {
  	"success": true
  }
  ```

- 如果当前用户不是订单的发起者，则返回错误信息



#### 5. 订单发货

##### `[POST] /api/orders/<int:order_id>/deliver`

##### Param

- order_id 为订单 id

##### Body

- 成功则返回提示信息

  ```json
  {
  	"success": true
  }
  ```

- 如果当前用户不是商品所在店铺的店主或管理员，则返回错误信息



#### 6. 订单确认

##### `[POST] /api/orders/<int:order_id>/confirm`

##### Param

order_id 为订单 id

##### Body

- 成功则返回提示信息

  ```json
  {
  	"success": true
  }
  ```

- 如果当前用户不是订单的发起者，则返回错误信息



#### 7. 用户获取自己的订单列表

##### `[GET] /api/user/orders/`

##### Query

- 必要参数：page
- 可选参数：page_size（默认为10）

##### Response

- 成功则返回下面的内容，包括：总数量`tot_count`，总页数`page_all`， 当前页号`page`， 订单列表`data`

  ```json
  {
      "tot_count": 2,
      "page_all": 1,
      "page": 1,
      "data": [
          {
              "id": 1,
              "num": 1,
              "price": "12.0",
              "status": 4,
              "start_time": "2023-01-03T00:53:04.534+08:00",
              "selected_options": ["雪碧", "北京"],
              "commodity_info": {
                  "id": 1,
                  "name": "汽水",
                  "price": "10.0",
                  "imgae_url": "....",
                  "shop_id": 1,
                  "shop_name": "czh的小店"
              }
          },
          {
              "id": 3,
              "num": 20,
              "price": "2000.0",
              "status": 5,
              "start_time": "2023-01-03T10:51:34.480+08:00",
          	"options": [],
              "commodity_info": {
                  "id": 3,
                  "name": "娃哈哈",
                  "price": "100.0",
                  "imgae_url": "....",
                  "shop_id": 1,
                  "shop_name": "czh的小店"
              }
          }
      ]
  }
  ```



#### 8. 店主或店铺管理员获取店铺的订单

##### `[GET] /api/shops/<int:shop_id>/orders`

##### Param

- shop_id 为店铺 id（默认page_size为10）

##### Query

- 必要参数：page
- 可选参数：page_size（默认为10）

##### Response

- 成功则返回下面的内容，包括：总数量`tot_count`，总页数`page_all`， 当前页号`page`， 订单列表`data`

  ```json
  {
      "tot_count": 2,
      "page_all": 1,
      "page": 1,
      "data": [
          {
              "id": 1,
              "num": 1,
              "price": "12.0",
              "status": 4,
              "start_time": "2023-01-03T00:53:04.534+08:00",
              "selected_options": ["雪碧", "北京"],
              "user_info": {
                  "id": 1,
                  "username": "czh"
              },
              "commodity_info": {
                  "id": 1,
                  "name": "汽水",
                  "price": "10.0",
                  "imgae_url": "...."
              }
          },
          {
              "id": 3,
              "num": 20,
              "price": "2000.0",
              "status": 5,
              "start_time": "2023-01-03T10:51:34.480+08:00",
              "options": [],
              "user_info": {
                  "id": 1,
                  "username": "czh"
              },
              "commodity_info": {
                  "id": 3,
                  "name": "娃哈哈",
                  "price": "100.0",
                  "imgae_url": "....",
              }
          }
      ]
  }
  ```

#### 9. 管理员获取订单列表

##### `[GET] /api/admin/orders`

##### Query

- 必要参数：page
- 可选参数：page_size（默认为10）

##### Response

- 成功则返回下面的内容，包括：总数量`tot_count`，总页数`page_all`， 当前页号`page`， 订单列表`data`

  ```json
  {
      "tot_count": 2,
      "page_all": 1,
      "page": 1,
      "data": [
          {
              "id": 1,
              "num": 1,
              "price": "12.0",
              "status": 4,
              "start_time": "2023-01-03T00:53:04.534+08:00",
              "selected_options": ["雪碧", "北京"],
              "user_info": {
                  "id": 1,
                  "username": "czh"
              },
              "commodity_info": {
                  "id": 1,
                  "name": "汽水",
                  "price": "10.0",
                  "imgae_url": "....",
                  "shop_id": 1,
                  "shop_name": "czh的小店"
              }
          },
          {
              "id": 3,
              "num": 20,
              "price": "2000.0",
              "status": 5,
              "start_time": "2023-01-03T10:51:34.480+08:00",
              "options": [],
              "user_info": {
                  "id": 1,
                  "username": "czh"
              },
              "commodity_info": {
                  "id": 3,
                  "name": "娃哈哈",
                  "price": "100.0",
                  "imgae_url": "....",
                  "shop_id": 1,
                  "shop_name": "czh的小店"
              }
          }
      ]
  }
  ```



### （7）评论相关接口

#### 1. 评价订单

##### `[POST] /api/orders/<int:order_id>/comments`

##### Param

- order_id 为订单 id

##### Body

- 必要字段：`grade` （商品评分 1~5）， `content`（评价内容）

  ```json
  {
      "grade": 5,
      "content": "很好"
  }
  ```

##### Response

- 成功则返回提示信息和id

  ```json
  {
      "success": true,
  	"id": 1
  }
  ```

- 如果当前用户不是订单发起人，则返回错误信息



#### 2. 获取评论详情

##### `[GET] /api/comments/<int:comment_id>`

##### Param

- comment_id 为评论 id

##### Response

- 成功则返回下面的信息，包括`id、grade、content、comment_time、user_info、order_info`
    - user_info是存储用户信息的哈希，包括`id, username, image_url`
    - order_info是存储订单信息的哈希，包括`id, price, num, options`，其中options是用户所选选项的名称列表

```json
{
	"id": 1,
	"grade": 5,
	"content": "很好",
	"comment_time": "2023-01-03T10:27:59.249+08:00",
	"user_info": {
		"id": 1,
		"username": "czh",
		"image_url": "http://localhost:3000/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBDQT09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--9678a3a147122250f7701fb1b2dfb5d6e4be52e6/head.jpg"
	},
	"order_info": {
		"id": 1,
		"price": "12.0",
		"num": 1,
		"options": [
			"雪碧",
			"北京"
		]
	}
}
```



#### 3. 获取商品评论列表

##### `[GET] /api/commodities/<int:commodity_id>/comments`

##### Param

- commodity_id 为商品 id

##### Response

- 成功则返回下面的内容，包括：总数量`tot_count`， 商品列表`data`

```json
{
	"tot_count": 1,
	"data": [
		{
			"id": 1,
			"username": "czh",
			"grade": 5,
			"content": "很好",
			"comment_time": "2023-01-03T10:27:59.249+08:00",
			"options": [
				"雪碧",
				"北京"
			]
		}
	]
}
```



### （8）文章相关接口

#### 1. 新建文章

##### `[POST] /api/articles`

##### Body

- 必要字段：`title`（文章标题）, `content`（文章内容）

- 可选字段：`commodity_id`（关联商品的id）

  ```json
  {
     "title": "肥宅快乐水",
     "content": "可乐（英文：Cola），是指有甜味、含咖啡因但不含乙醇的碳酸饮料。口味包括有香草、肉桂、柠檬香味等。名称来自可乐早期的材料之一：可乐果提取物。最知名的可乐品牌有可口可乐和百事可乐。喝可乐本来是跟喝其他饮料没什么差别的消费行为。但是，内涵丰富的可乐文化，远超出了“喝饮料”的范畴。",
     "commodity_id": 1
  }
  ```

##### Response

- 成功则返回提示信息和文章id

  ```json
  {
  	"success": true,
  	"id": 3
  }
  ```



#### 2. 修改文章内容

##### `[PUT] /api/articles/<int:article_id>`

##### Param

- article_id 为文章 id

##### Body

- 可选字段：title, content, commodity_id

  ```json
  {
     "title": "超级好喝的肥宅快乐水",
     "content": "可乐（英文：Cola），是指有甜味、含咖啡因但不含乙醇的碳酸饮料。口味包括有香草、肉桂、柠檬香味等。名称来自可乐早期的材料之一：可乐果提取物。最知名的可乐品牌有可口可乐和百事可乐。喝可乐本来是跟喝其他饮料没什么差别的消费行为。但是，内涵丰富的可乐文化，远超出了“喝饮料”的范畴。<br>可乐是由美国的一位名叫约翰·彭伯顿的药剂师发明的。他期望创造出一种能提神、解乏、治头痛的药用混合饮料。彭伯顿调制的“可卡可拉”，起初是不含气体的，饮用时兑上凉水，只是由于一次偶然的意外，才变成了碳酸饮料。1886年5月8日下午，一个酒鬼跌跌撞撞地来到了彭伯顿的药店。对营业员说：“来一杯治疗头痛脑热的药水可卡可拉。”营业员本来应该到水龙头那儿去兑水，但水龙头离他有两米多远，他懒得走动，便就近抄起苏打水往可卡可拉里掺。结果酒鬼居然挺喜欢喝，他喝了一杯又一杯，嘴里不停地说：“好喝。好喝。”酒鬼还到处宣传这种不含酒精的饮料所产生的奇效。在约翰·彭伯顿去世前，他们把专利权出售。四十年后，世界上无人不知可口可乐。 一种含有可乐果提取物及其他调味品的碳酸软饮料，刚开始源于美国。但是，可乐中含有咖啡因，是一种对人体有害的物质，但是还有益处，可乐中含有二氧化碳大家都是知道的，二氧化碳到了人体里再呃逆出来的时候就会把人体的热量带走，可以散热。",
     "commodity_id": 1
  }
  ```

##### Response

- 成功则返回提示信息和文章id

  ```json
  {
  	"success": true,
  	"id": 3
  }
  ```

- 如果当前用户不是文章作者或者管理员，返回错误信息



#### 3. 删除文章

##### `[DELETE] /api/articles/<int:article_id>`

##### Param

- article_id 为文章 id

##### Response

- 成功则返回提示信息和文章id

  ```json
  {
  	"success": true,
  	"id": 3
  }
  ```

- 如果当前用户不是文章作者或者管理员，返回错误信息




#### 4. 查看文章详情

##### `[GET] /api/articles/<int:article_id>`

##### Param

- article_id 为文章 id

##### Response

- 成功则返回下面的内容，包括`id, title, content, post_time, author_info, commodity_in`
    - author_info是存储作者信息的哈希，包括`id, username`
    - commodity_info是存储商品信息的哈希, 包括`id, name, price, image_url`

```json
{
	"id": 3,
	"title": "肥宅快乐水",
	"content": "可乐（英文：Cola），是指有甜味、含咖啡因但不含乙醇的碳酸饮料。口味包括有香草、肉桂、柠檬香味等。名称来自可乐早期的材料之一：可乐果提取物。最知名的可乐品牌有可口可乐和百事可乐。喝可乐本来是跟喝其他饮料没什么差别的消费行为。但是，内涵丰富的可乐文化，远超出了“喝饮料”的范畴。",
	"post_time": "2023-01-03T22:18:26.662+08:00",
	"author_info": {
		"id": 1,
		"username": "czh"
	},
	"commodity_info": {
		"id": 1,
		"name": "汽水",
		"price": "10.0",
		"image_url": "http://localhost:3000/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBCZz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--f9be98befd8ef27ad3c8bb33f7f57380aabd2200/%E5%BD%95%E5%8F%96%E9%80%9A%E7%9F%A5%E4%B9%A6.jpg"
	}
}
```



#### 5. 用户查看文章列表

##### `[GET] /api/articles`

##### Query

- 必要参数：page
- 可选参数：page_size（默认为12）
- 必要参数：keyword

##### Response

- 成功则返回下面的内容，包括：总数量`tot_count`，总页数`page_all`， 当前页号`page`， 文章列表`data`

  ```json
  {
      "tot_count": 3,
      "page_all": 1,
      "page": 1,
      "data": [
          {
              "id": 1,
              "title": "推荐一个好喝的饮料...",
              "content": "娃哈哈太好喝啦",
              "post_time": "2023-01-03T11:58:19.699+08:00",
              "author_info": {
                  "id": 1,
                  "username": "czh"
              }
          },
          {
              "id": 2,
              "title": "推荐一个好喝的饮料",
              "content": "可乐雪碧太好喝啦",
              "post_time": "2023-01-03T12:01:58.214+08:00",
              "author_info": {
                  "id": 1,
                  "username": "czh"
              }
          },
          {
              "id": 3,
              "title": "肥宅快乐水",
              "content": "可乐（英文：Cola），是指有甜味、含咖啡因但不含乙醇的碳酸饮料。口味包括有香草、肉桂、柠檬香味等。名称来自可乐早期的材料之一：可乐果提取物。最知名的可乐品牌有可口可乐和百事可乐。喝可乐本来是跟喝其他饮料没什么差别的消费行为。但是，内涵丰富的可乐文化，远超出了“喝饮料”的范畴。",
              "post_time": "2023-01-03T22:18:26.662+08:00",
              "author_info": {
                  "id": 1,
                  "username": "czh"
              }
          }
      ]
  }
  ```



### （9）回复相关接口

#### 1. 用户对文章回复

##### `[POST] /api/articles/<int:article_id>/replies`

##### Param

- article_id 为文章 id

##### Body

- 必要字段：content（回复内容）

- 可选字段：refer_id（引用的回复的id，表示对其他回复进行回复）

  ```json
  {
     "content": "我也觉得",
     "refer_id": 4
  }
  ```

##### Response

- 成功则返回提示信息和回复id

  ```json
  {
  	"success": true,
  	"id": 5
  }
  ```

- 如果引用的回复不属于该文章，则返回错误信息



#### 2. 删除回复

##### `[DELETE] /api/replies/<int:reply_id>`

##### Param

- article_id 为文章 id

##### Response

- 成功则返回提示信息和回复id

  ```json
  {
  	"success": true,
  }
  ```

- 如果当前用户不是写回复的人或者管理员，则返回错误信息

> 为了防止删除后楼层出现混乱，我们并没有真正将该回复从数据库中删除，而设置`is_deleted`字段作为标记。



#### 3. 修改回复详情

##### `[PUT] /api/replies/<int:reply_id>`

##### Param

- article_id 为文章 id

##### Body

- 可选字段：content

  ```json
  {
      "content": "有一说一，确实"
  }
  ```

##### Response

- 功则返回提示信息和回复id

  ```json
  {
  	"success": true,
  }
  ```

- 如果当前用户不是写回复的人或者管理员，则返回错误信息



#### 4. 查看文章的所有回复

##### `[GET] /api/articles/<int:article_id>/replies`

##### Param

- article_id 为文章 id

##### Response

- 成功则返回下面的内容，包括：总数量`tot_count`，回复列表`data`

```json
{
	"tot_count": 2,
	"data": [
		{
			"id": 4,
			"floor": 1,
			"content": "说的挺全的",
			"is_deleted": 0,
			"user_info": {
				"id": 1,
				"username": "czh",
				"image_url": "http://localhost:3000/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBDQT09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--9678a3a147122250f7701fb1b2dfb5d6e4be52e6/head.jpg"
			},
			"refer_info": null
		},
		{
			"id": 5,
			"floor": 2,
			"content": "有一说一，确实",
			"is_deleted": 0,
			"user_info": {
				"id": 1,
				"username": "czh",
				"image_url": "http://localhost:3000/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBDQT09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--9678a3a147122250f7701fb1b2dfb5d6e4be52e6/head.jpg"
			},
			"refer_info": {
				"id": 4,
				"floor": 1
			}
		}
	]
}
```



### （10）文件相关接口

#### 1. 上传图片

##### `[POST] /api/images`

##### Body

- 必要字段：file 表示要上传的文件

##### Response

- 成功则返回提示信息和图片id

  ```json
  {
      "success": true,
      "id": 1
  }
  ```



#### 2. 获取图片链接

##### `[GET] /api/images/<int:image_id>/url`

##### Param

- image_id 为图片 id

##### Response

- 成功则返回图片链接——image_url

  ```json
  {
  	"image_url": "http://localhost:3000/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBCZz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--f9be98befd8ef27ad3c8bb33f7f57380aabd2200/%E5%BD%95%E5%8F%96%E9%80%9A%E7%9F%A5%E4%B9%A6.jpg"
  }
  ```



#### 3. 设置用户头像

##### `[POST] /api/images/<int:image_id>/set_user_image`

##### Param

- image_id 为图片 id

##### Body

- 成功则返回提示信息

  ```json
  {
      "success": true,
  }
  ```



#### 4. 设置店铺图片

##### `[POST] /api/images/<int:image_id>/set_shop_image`

##### Param

- image_id 为图片 id

##### Body

- 必要字段：shop_id

  ```json
  {
  	"shop_id": 2
  }
  ```

##### Response

- 成功则返回提示信息

  ```json
  {
      "success": true,
  }
  ```

- 如果当前用户不是店铺管理员或者店主，返回错误信息



#### 5. 设置商品图片

##### `[POST] /api/images/<int:image_id>/set_commodity_image`

##### Param

- image_id 为图片 id

##### Body

- 必要字段：commodity_id

  ```json
  {
  	"commodity_id": 3
  }
  ```

##### Response

- 成功则返回提示信息

  ```json
  {
      "success": true,
  }
  ```

- 如果当前用户不是店铺管理员或者店主，返回错误信息

  