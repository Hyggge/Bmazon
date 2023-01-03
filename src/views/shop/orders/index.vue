<template>
  <d2-container>
    <template v-slot:header>
      <el-form ref="form" label-width="100px">
        <el-form-item label="请选择店铺" style="height: 10px">
          <el-select v-model="curShopId" placeholder="请选择">
            <el-option
              v-for="item in shopList"
              :key="item.id"
              :label="item.name"
              :value="item.id">
            </el-option>
          </el-select>
        </el-form-item>
      </el-form>
    </template>

    <el-table :data="tableData"
              style="width: 100%" border
              highlight-current-row
              @sort-change="handleSortChange">
      <el-table-column
        prop="picture"
        label="商品图片"
        align="center"
        width="80">
        <template v-slot="scope">
          <div v-if="scope.$index === 0">
          </div>
          <div v-else>
            <img :src="scope.row.image_url" style="height: 100%; height: 80px">
          </div>
        </template>
      </el-table-column>
      <el-table-column
        prop="picture"
        label="商品名称"
        align="center"
        width="100">
        <template v-slot="scope">
          <div v-if="scope.$index === 0">
            <el-input
              v-model="query.commodityName"
              size="small"
              placeholder="查询商品名称"
              @change="queryOrdersByCommodityName"
            />
          </div>
          <div v-else>
            <el-row>{{scope.row.commodity__name}}</el-row>
            <el-row style="margin-top: 10px">
              <el-tag v-for="(param, index) in scope.row.select_paras"
                      :key="index" style="margin-left: 10px" size="mini">
                {{param}}
              </el-tag>
            </el-row>
          </div>
        </template>
      </el-table-column>
      <el-table-column
        prop="num"
        label="购买数量"
        sortable="custom"
        align="center"
        width="80">
        <template v-slot="scope">
          <div v-if="scope.$index === 0">
            <el-input
              v-model="query.num"
              size="small"
              placeholder="查询数量"
              @change="queryOrdersByNum"
            />
          </div>
          <div v-else>
            {{scope.row.num}}
          </div>
        </template>
      </el-table-column>
      <el-table-column
        prop="price"
        sortable="custom"
        label="实付金额"
        align="center"
        width="80">
        <template v-slot="scope">
          <div v-if="scope.$index === 0">
            <el-input
              v-model="query.price"
              size="small"
              placeholder="查询金额"
              @change="queryOrdersByPrice"
            />
          </div>
          <div v-else>
            {{'¥' + scope.row.price}}
          </div>
        </template>
      </el-table-column>
      <el-table-column
        prop="picture"
        label="用户昵称"
        align="center"
        width="80">
        <template v-slot="scope">
          <div v-if="scope.$index === 0">
            <el-input
              v-model="query.userNickname"
              size="small"
              placeholder="查询用户昵称"
              @change="queryOrdersByUserNickname"
            />
          </div>
          <div v-else>
            {{scope.row.user__nickname}}
          </div>
        </template>
      </el-table-column>
      <el-table-column
        prop="picture"
        label="交易状态"
        align="center"
        width="250">
        <template v-slot="scope">
          <div v-if="scope.$index === 0">
            <el-select v-model="query.status" clearable placeholder="请选择" style="width: 100%" @change="queryOrdersByStatus">
              <el-option label="已下单" :value="0"></el-option>
              <el-option label="已支付" :value="1"></el-option>
              <el-option label="已发货" :value="2"></el-option>
              <el-option label="已收货" :value="3"></el-option>
              <el-option label="已评价" :value="4"></el-option>
              <el-option label="已关闭" :value="5"></el-option>
            </el-select>
          </div>
          <div v-else>
            <el-steps  v-if="scope.row.status !== 5"
                       :space="200" :active="scope.row.status + 1"
                       finish-status="success"
                       style="margin-left: 20px; margin-right: 10px; ">
              <el-step title="下单"></el-step>
              <el-step title="支付"></el-step>
              <el-step title="发货"></el-step>
              <el-step title="收货"></el-step>
              <el-step title="评价"></el-step>
              <!--<el-step title="关闭"></el-step>-->
            </el-steps>
            <div v-else>订单已经关闭</div>
            <!--<el-tag :type="tagTypeList[scope.row.status]"><strong>{{statusList[scope.row.status]}}</strong></el-tag>-->
          </div>
        </template>
      </el-table-column>
      <el-table-column
        prop="start_time"
        sortable="custom"
        label="下单时间"
        align="center"
        width="120">
        <template v-slot="scope">
          <div v-if="scope.$index === 0">
            <el-date-picker
              v-model="query.startTime"
              type="date"
              value-format="yyyy-MM-dd"
              @change="queryOrdersByStartTime"
              style="width: 100%"
              placeholder="选择日期">
            </el-date-picker>
          </div>
          <div v-else>
            {{ formatTime(scope.row.start_time) }}
          </div>
        </template>
      </el-table-column>
      <el-table-column
        prop="picture"
        align="center"
        width="80">
        <template v-slot="scope">
          <div v-if="scope.$index === 0"></div>
          <div v-else>
            <el-row style="margin-top: 10px">
              <el-button type="primary" size="mini" @click="getOrderDetails(scope.row.id)">查看详情</el-button>
            </el-row>
            <el-row v-if="scope.row.status === 1" style="margin-top: 10px">
              <el-button type="danger" size="mini" @click="deliverCommodity(scope.row.id)">发货</el-button>
            </el-row>
          </div>
        </template>
      </el-table-column>
    </el-table>

    <!--分页栏-->
    <div class="block" style="margin-top: 10px">
      <el-pagination
        hi
        background
        layout="prev, pager, next,jumper, ->, total, slot"
        :total="filterTotalCnt"
        @current-change="handleCurrentChange"
        :current-page="currentPage"
        :page-size="10"
        style="text-align: center">
      </el-pagination>
    </div>

    <!--抽屉-->
    <el-drawer
      title="订单详情"
      :visible.sync="drawer"
      direction="rtl">
      <!--商品图片-->
      <img :src="curOrderDetails.image_url" style="width: 100%; margin-bottom: 10px" alt="">

      <el-descriptions :column="2"  border>
        <el-descriptions-item :span="2">
          <template slot="label">
            商品名称
          </template>
          {{curOrderDetails.commodity__name}}
        </el-descriptions-item>
        <el-descriptions-item :span="2">
          <template slot="label">
            店铺名称
          </template>
          {{curOrderDetails.commodity__shop__name}}
        </el-descriptions-item>
        <el-descriptions-item :span="2">
          <template slot="label">
            购买数量
          </template>
          {{curOrderDetails.num}}
        </el-descriptions-item>
        <el-descriptions-item :span="2">
          <template slot="label">
            购买金额
          </template>
          {{'¥' + curOrderDetails.price}}
        </el-descriptions-item>
        <el-descriptions-item :span="2">
          <template slot="label">
            交易状态
          </template>
          <el-tag v-if="curOrderDetails.status == 0" type="warning" size="mini">已下单</el-tag>
          <el-tag v-if="curOrderDetails.status == 1" type="primary" size="mini">已支付</el-tag>
          <el-tag v-if="curOrderDetails.status == 2" type="warning" size="mini">已发货</el-tag>
          <el-tag v-if="curOrderDetails.status == 3" type="success" size="mini">已收货</el-tag>
          <el-tag v-if="curOrderDetails.status == 4" type="success" size="mini">已评价</el-tag>
          <el-tag v-if="curOrderDetails.status == 5" type="info" size="mini">已关闭</el-tag>
        </el-descriptions-item>
        <el-descriptions-item :span="2">
          <template slot="label">
            交易地址
          </template>
          {{curOrderDetails.address === '' ? '无' : curOrderDetails.address}}
        </el-descriptions-item>
        <el-descriptions-item :span="2">
          <template slot="label">
            备注
          </template>
          {{curOrderDetails.note === '' ? '无' : curOrderDetails.note}}
        </el-descriptions-item>
        <el-descriptions-item v-if="curOrderDetails.status >= 0" :span="2">
          <template slot="label">
            下单时间
          </template>
          {{curOrderDetails.start_time === null ? '无' : curOrderDetails.start_time }}
        </el-descriptions-item>
        <el-descriptions-item v-if="curOrderDetails.status >= 1 && curOrderDetails.status !== 5" :span="2">
          <template slot="label">
            支付时间
          </template>
          {{curOrderDetails.pay_time === null ? '无' : curOrderDetails.pay_time }}
        </el-descriptions-item>
        <el-descriptions-item v-if="curOrderDetails.status >= 2 && curOrderDetails.status !== 5" :span="2">
          <template slot="label">
            发货时间
          </template>
          {{curOrderDetails.deliver_time === null ? '无' : curOrderDetails.deliver_time }}
        </el-descriptions-item>
        <el-descriptions-item v-if="curOrderDetails.status >= 3 && curOrderDetails.status !== 5" :span="2">
          <template slot="label">
            收货时间
          </template>
          {{curOrderDetails.confirm_time === null ? '无' : curOrderDetails.confirm_time }}
        </el-descriptions-item>
        <el-descriptions-item v-if=" curOrderDetails.status === 5" :span="2">
          <template slot="label">
            关闭时间
          </template>
          {{curOrderDetails.close_time === null ? '无' : curOrderDetails.close_time }}
        </el-descriptions-item>
      </el-descriptions>
    </el-drawer>

  </d2-container>

</template>

<script>
import api from '@/api'
import util from '@/libs/util'

export default {
  name: 'shop-orders',
  data () {
    return {
      // 当前用户id
      userId: this.$store.state.d2admin.user.info.id,
      // 店铺列表
      shopList: [],
      // 当前店铺的id
      curShopId: 0,
      // 抽屉
      drawer: false,
      // 正在展示的订单详情
      curOrderDetails: {},
      // 用户输入的查询信息
      query: {
        commodityName: '',
        num: '',
        price: '',
        status: '',
        startTime: '',
        userNickname: ''
      },
      // 当前页面
      currentPage: 1,
      // 筛选之后的记录总数
      filterTotalCnt: 0,
      // 筛选器和排序规则，用于构造请求的params
      filter: {},
      orderBy: '',
      // 表格数据
      tableData: [{}]
    }
  },
  methods: {
    formatTime: util.time.formatTime,
    /**
     * 获得商铺列表
     */
    async getShopList () {
      const res = await api.GET_USER_SHOP_LIST(this.userId)
      this.shopList = res.owner_shop.concat(res.admin_shop)
    },
    /**
     * 获取当前店铺的所有订单
     */
    async queryOrders () {
      // 构造params
      const params = {
        ...this.filter,
        page: this.currentPage
      }
      // 将order_by加入params
      if (this.orderBy !== null && this.orderBy !== '') {
        params.order_by = this.orderBy
      } else {
        params.order_by = '-start_time' // 默认通过下单时间降序排列
      }
      // 发送请求
      const res = await api.GET_ORDER_LIST_FOR_SHOP(this.curShopId, params)
      console.log(res.data)
      this.tableData = res.data
      this.tableData.unshift({})
      this.filterTotalCnt = res.filter_count
    },
    /**
     * 响应用户对展示页面下标的修改
     * 并重新发送请求
     */
    handleCurrentChange (value) {
      this.currentPage = value
      this.queryOrders()
    },
    /**
     * 响应用户对排序规则的修改
     * 并重新发送请求
     */
    handleSortChange (value) {
      if (value.prop === 'num') {
        if (value.order === 'ascending') {
          this.orderBy = 'num'
        } else if (value.order === 'descending') {
          this.orderBy = '-num'
        } else {
          this.orderBy = null
        }
      }
      if (value.prop === 'price') {
        if (value.order === 'ascending') {
          this.orderBy = 'price'
        } else if (value.order === 'descending') {
          this.orderBy = '-price'
        } else {
          this.orderBy = null
        }
      }
      if (value.prop === 'start_time') {
        if (value.order === 'ascending') {
          this.orderBy = 'start_time'
        } else if (value.order === 'descending') {
          this.orderBy = '-start_time'
        } else {
          this.orderBy = null
        }
      }
      console.log(this.orderBy)
      this.currentPage = 1
      this.queryOrders()
    },
    /**
     * 根据用户输入的商品名查询
     */
    queryOrdersByCommodityName () {
      if (this.query.commodityName !== '') {
        Object.assign(this.filter, { commodity__name__contains: this.query.commodityName })
      } else {
        delete this.filter.commodity__name__contains
      }
      this.currentPage = 1
      this.queryOrders()
    },
    /**
     * 根据用户输入的商品数量进行查询
     */
    queryOrdersByNum () {
      if (this.query.num !== '') {
        Object.assign(this.filter, { num__exact: this.query.num })
      } else {
        delete this.filter.num__exact
      }
      this.currentPage = 1
      this.queryOrders()
    },
    /**
     * 根据用户输入的商品金额进行查询
     */
    queryOrdersByPrice () {
      if (this.query.price !== '') {
        Object.assign(this.filter, { price__exact: this.query.price })
      } else {
        delete this.filter.price__exact
      }
      this.currentPage = 1
      this.queryOrders()
    },
    /**
     * 根据用户输入的用户昵称进行查询
     */
    queryOrdersByUserNickname () {
      if (this.query.userNickname !== '') {
        Object.assign(this.filter, { user__nickname__contains: this.query.userNickname })
      } else {
        delete this.filter.user__nickname__contains
      }
      this.currentPage = 1
      this.queryOrders()
    },
    /**
     * 根据用户输入的商品状态进行查询
     */
    queryOrdersByStatus () {
      if (this.query.status !== '') {
        Object.assign(this.filter, { status__exact: this.query.status })
      } else {
        delete this.filter.status__exact
      }
      this.currentPage = 1
      this.queryOrders()
    },
    /**
     * 根据用户输入的下单时间进行查询
     */
    queryOrdersByStartTime () {
      if (this.query.startTime !== null && this.query.startTime !== '') {
        const date = this.query.startTime.split('-')
        Object.assign(this.filter, { start_time__year: date[0], start_time__month: date[1], start_time__day: date[2] })
      } else {
        delete this.filter.start_time__year
        delete this.filter.start_time__month
        delete this.filter.start_time__day
      }
      this.currentPage = 1
      this.queryOrders()
    },
    /**
     * 获得订单详情
     */
    async getOrderDetails (orderId) {
      this.drawer = true;
      this.curOrderDetails = await api.GET_ORDER_DETAILS(orderId)
      console.log(this.curOrderDetails)
    },
    /**
     * 商家发货
     */
    async deliverCommodity (orderId) {
      await this.$confirm('是否已经发货', '提示', {
        confirmButtonText: '是',
        cancelButtonText: '否',
        type: 'warning'
      })
      await api.DELIVER_COMMODITY(orderId)
      await this.queryOrders()
      this.$Message.success('发货成功！')
    }
  },
  watch: {
    curShopId: {
      handler (newVal) {
        this.queryOrders()
      }
    }
  },
  mounted () {
    this.getShopList().then(() => {
      if (this.shopList.length === 0) {
        this.$router.push({ path: '/shop/create' })
        this.$Message.warning('您还没有创建店铺!')
      } else {
        this.curShopId = this.shopList[0].id
      }
    })
  }
}
</script>

<style scoped>

</style>
