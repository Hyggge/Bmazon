<template>
  <d2-container>
    <template v-slot:header>
      <el-row>
        <el-col :span="3"><h2>我的收藏</h2></el-col>
      </el-row>
    </template>

    <!--商品列表-->
    <el-row :gutter="30">
      <div v-for="commodity in commodityList" :key="commodity.id">
        <el-col :span="6" style="margin-bottom: 20px" >
          <div @click="showDetails(commodity.id)">
            <el-card style="height: 400px; cursor: pointer">
              <!--商品图片-->
              <div style="height: 200px">
                <el-image :src="commodity.image_url" style="width: 100%; height: 100%" fit="fill"></el-image>
              </div>
              <!--商品介绍-->
              <h4 style="height: 70px; color: grey; margin-top: 10px">
                {{modifyIntroduction(commodity.introduction, 50)}}
              </h4>
              <!--商品名称-->
              <h2>{{modifyIntroduction(commodity.name, 10)}}</h2>
              <!--商品价格-->
              <h2 style="color: #ff8226">
                {{`¥` + parseFloat(commodity.price).toFixed(2) }}
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
    </el-row>
  </d2-container>
</template>

<script>
import api from '@/api'
// import echarts from "_echarts@5.4.1@echarts";

export default {
  name: 'collections',
  data () {
    return {
      // 商品列表
      commodityList: [],
      // 当前页面
      currentPage: 1,
      // 筛选之后的记录总数
      filterTotalCnt: 0
    }
  },
  methods: {
    async getCollectedCommodities () {
      const res = await api.GET_COLLECTED_COMMODITY_LIST({ page: this.currentPage })
      this.commodityList = res.data
      this.filterTotalCnt = res.tot_count
      console.log(res)
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
    this.getCollectedCommodities()
  }
}
</script>

<style scoped>

</style>
