<template>
  <d2-container ref="container">
    <template v-slot:header>
      <!--搜索框-->
      <div style="text-align: center">
        <el-input
          type="text"
          prefix-icon="el-icon-search"
          v-model="query.keyword"
          placeholder="请输入想过搜索的商品名称"
          style="width: 500px; cursor: pointer"
          @keyup.enter.native="queryCommodities"
        ></el-input>
        <el-button type="danger" style="margin-left: 10px" @click="queryCommodities">搜索</el-button>
      </div>
    </template>

    <!--筛选-->
    <el-form :inline="true" :model="query" class="demo-form-inline" size="mini">
      <el-form-item label="最低价">
        <el-input v-model="query.minPrice" placeholder="请输入" @change="queryCommoditiesByMinPrice" ></el-input>
      </el-form-item>
      <el-form-item label="最高价">
        <el-input v-model="query.maxPrice" placeholder="请输入" @change="queryCommoditiesByMaxPrice" ></el-input>
      </el-form-item>
      <el-form-item label="商品状态">
        <el-select v-model="query.status" multiple placeholder="请选择" clearable @change="queryCommoditiesByStatus">
          <el-option label="预售中" :value="1">预售中</el-option>
          <el-option label="售卖中" :value="2">售卖中</el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="交易方式">
        <el-select v-model="query.method" placeholder="请选择" multiple clearable @change="queryCommoditiesByMethod">
          <el-option label="线上交易" :value="0">线上交易</el-option>
          <el-option label="线下自取" :value="1">线下自取</el-option>
          <el-option label="送货上门" :value="2">送货上门</el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="排序规则">
        <el-select v-model="orderBy" placeholder="请选择" clearable @change="queryCommodities">
          <el-option label="价格升序" :value="0"> </el-option>
          <el-option label="价格降序" :value="1"> </el-option>
          <el-option label="销量升序" :value="2"> </el-option>
          <el-option label="销量降序" :value="3"> </el-option>
        </el-select>
      </el-form-item>
    </el-form>

    <!--商品列表-->
    <el-row :gutter="30">
      <div v-for="commodity in commodityList" :key="commodity.id">
        <el-col :span="6" style="margin-bottom: 20px" >
          <div @click="showDetails(commodity.id)">
            <el-card style="height: 400px; cursor: pointer">
              <!--商品图片-->
              <div style="height: 200px">
                <img :src="commodity.img_url" style="width: 100%; height: 100%">
              </div>
              <!--商品介绍-->
              <h4 style="height: 70px; color: grey; margin-top: 10px">
                {{modifyIntroduction(commodity.introduction, 50)}}
              </h4>
              <!--商品名称-->
              <h2>{{modifyIntroduction(commodity.name, 10)}}</h2>
              <!--商品价格-->
              <h2 style="color: #ff8226">
                {{`¥` + (commodity.price - commodity.discount).toFixed(2)}}
              </h2>
              <!--商品的状态和交易方式-->
              <div>
                <span>
                  <el-tag v-if="commodity.status === 1" type="warning" size="mini"><strong>预售中</strong></el-tag>
                  <el-tag v-if="commodity.status === 2" type="success" size="mini"><strong>售卖中</strong></el-tag>
                </span>
                <span style="margin-left: 10px;">
                  <el-tag v-if="commodity.method === 0" type="success" size="mini"><strong>线上交易</strong></el-tag>
                  <el-tag v-if="commodity.method === 1" type="primary" size="mini"><strong>线下自取</strong></el-tag>
                  <el-tag v-if="commodity.method === 2" type="warning" size="mini"><strong>送货上门</strong></el-tag>
                </span>
              </div>
            </el-card>
          </div>
        </el-col>
      </div>
    </el-row>

    <!--分页栏-->
    <div class="block" style="margin-top: 10px">
      <el-pagination
        hi
        background
        layout="prev, pager, next,jumper, ->, total, slot"
        :total="filterTotalCnt"
        @current-change="handleCurrentChange"
        :current-page="currentPage"
        :page-size="12"
        style="text-align: center">
      </el-pagination>
    </div>

  </d2-container>
</template>

<script>
import api from '@/api'

export default {
  name: 'show-all-commodities',
  data () {
    return {
      // 商品列表
      commodityList: [],
      // 用户输入的查询条件
      query: {
        keyword: '',
        minPrice: '',
        maxPrice: '',
        status: [],
        method: [],
        minSale: '',
        haveStock: ''
      },
      // 筛选器
      filter: {},
      // 排序规则
      orderBy: 0, // 0表示价格升序, 1表示价格降序, 2表示销量升序, 3表示销量降序
      // 当前页面
      currentPage: 1,
      // 筛选之后的记录总数
      filterTotalCnt: 0
    }
  },
  methods: {
    /**
     * 获得商品列表
     */
    async queryCommodities () {
      console.log(this.orderBy)
      const data = {
        keyword: this.query.keyword, // keyword字段是必须的
        ...this.filter
      }
      // 加入排序规则
      if (this.orderBy === 0) {
        data.order_by = 'price'
      } else if (this.orderBy === 1) {
        data.order_by = '-price'
      } else if (this.orderBy === 2) {
        data.order_by = 'sale'
      } else {
        data.order_by = '-sale'
      }
      // 发送请求
      const res = await api.GET_COMMODITY_LIST_FOR_USER(this.currentPage, data)
      this.commodityList = res.data
      this.filterTotalCnt = res.tot_count
      console.log(res)
    },
    /**
     * 根据用户输入的最小价格进行查询
     */
    queryCommoditiesByMinPrice () {
      if (this.query.minPrice !== '') {
        Object.assign(this.filter, { min_price: this.query.minPrice })
      } else {
        delete this.filter.min_price
      }
      this.currentPage = 1
      this.queryCommodities()
    },
    /**
     * 根据用户输入的最大价格进行查询
     */
    queryCommoditiesByMaxPrice () {
      if (this.query.maxPrice !== '') {
        Object.assign(this.filter, { max_price: this.query.maxPrice })
      } else {
        delete this.filter.max_price
      }
      this.currentPage = 1
      this.queryCommodities()
    },
    /**
     * 根据用户输入的商品状态进行查询
     */
    queryCommoditiesByStatus () {
      console.log(this.query.status)
      if (this.query.status.length !== 0) {
        Object.assign(this.filter, { status: this.query.status })
      } else {
        this.filter.status = [1, 2]
      }
      this.currentPage = 1
      this.queryCommodities()
    },
    /**
     * 根据用户输入的交易方式进行查询
     */
    queryCommoditiesByMethod () {
      if (this.query.method.length !== 0) {
        Object.assign(this.filter, { method: this.query.method })
      } else {
        delete this.filter.method
      }
      this.currentPage = 1
      this.queryCommodities()
    },
    /**
     * 修改商品介绍
     */
    modifyIntroduction (introduction, maxLength) {
      const ans = String(introduction)
      if (ans.length > maxLength) {
        return ans.slice(0, maxLength) + '...'
      } else {
        return ans
      }
    },
    /**
     * 展示商品细节
     */
    showDetails (commodityId) {
      this.$router.push({ path: `/commodity/show-details/${commodityId}` })
    },
    /**
     * 响应用户对展示页面下标的修改
     * 并重新发送请求
     */
    async handleCurrentChange (value) {
      this.currentPage = value
      await this.queryCommodities(value, { keyword: '' })
      this.$refs.container.scrollToTop()
    }
  },
  mounted () {
    this.filter.status = [1, 2] // 只允许预售和在售的商品出现
    this.queryCommodities()
  }
}
</script>

<style scoped>

</style>
