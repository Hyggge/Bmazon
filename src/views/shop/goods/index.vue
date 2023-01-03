<template>
  <d2-container>
    <template v-slot:header>
      <el-form ref="form" :model="form" label-width="100px">
        <el-form-item label="请选择店铺" style="height: 10px">
          <el-select v-model="curShopId" placeholder="请选择">
            <el-option
              v-for="item in shopList"
              :key="item.id"
              :label="item.name"
              :value="item.id">
            </el-option>
          </el-select>
          <el-button type="success" style="margin-left: 10px" @click="goToCreateCommodity"> 增加商品 </el-button>
        </el-form-item>
      </el-form>
    </template>

    <el-table :data="curCommodityList" style="width: 100%" border>
      <el-table-column
        prop="picture"
        label="商品图片"
        align="center"
        width="80">
        <template v-slot="scope">
          <img :src="scope.row.img_url" style="width: 100%; height: 80px">
        </template>
      </el-table-column>
      <el-table-column
        prop="name"
        label="商品名"
        align="center"
        width="120">
      </el-table-column>
      <el-table-column
        prop="price"
        label="价格"
        align="center"
        width="120">
      </el-table-column>
      <el-table-column
        prop="discount"
        label="优惠"
        align="center"
        width="120">
        <template v-slot="scope">
          {{ scope.row.discount }}
          <el-popover
            placement="top-start"
            title="请输入新的商品折扣"
            width="200"
            trigger="click">
            <el-input v-model="newDiscount" placeholder="请输入0~1之间的两位小数"></el-input>
            <div style="text-align: center">
              <el-button size="mini" type="primary" style="margin-top: 10px" @click="changeDiscount(scope.row.id)">提交</el-button>
            </div>
            <el-link icon="el-icon-edit" style="margin-left: 3px" slot="reference"></el-link>
          </el-popover>
        </template>
      </el-table-column>
      <el-table-column
        prop="discount"
        label="折后价格"
        align="center"
        width="120">
        <template v-slot="scope">
          {{formatPrice(scope.row.price, scope.row.discount, 0)}}
        </template>
      </el-table-column>
      <el-table-column
        prop="method"
        label="交易方式"
        align="center"
        width="120">
        <template v-slot="scope">
          <el-tag v-if="scope.row.method === 0" type="success" effect="plain"><strong>线上交易</strong></el-tag>
          <el-tag v-if="scope.row.method === 1" type="primary" effect="plain"><strong>线下自取</strong></el-tag>
          <el-tag v-if="scope.row.method === 2" type="warning" effect="plain"><strong>送货上门</strong></el-tag>

        </template>
      </el-table-column>
      <el-table-column
        prop="status"
        label="商品状态"
        align="center"
        width="120">
        <template v-slot="scope">
          <el-tag v-if="scope.row.status === 0" type="primary"><strong>未生效</strong></el-tag>
          <el-tag v-if="scope.row.status === 1" type="warning"><strong>预售中</strong></el-tag>
          <el-tag v-if="scope.row.status === 2" type="success"><strong>售卖中</strong></el-tag>
          <el-tag v-if="scope.row.status === 3" type="info"><strong>已下架</strong></el-tag>
          <el-popover
            placement="top-start"
            title="请选择新的商品状态"
            width="200"
            trigger="click">
            <el-select v-model="newStatus" placeholder="请选择">
              <el-option label="未生效" :value="0"></el-option>
              <el-option label="预售中" :value="1"></el-option>
              <el-option label="售卖中" :value="2"></el-option>
              <el-option label="已下架" :value="3"></el-option>
            </el-select>
            <div style="text-align: center">
              <el-button size="mini" type="primary" style="margin-top: 10px" @click="changeStatus(scope.row.id)">提交</el-button>
            </div>
            <el-link icon="el-icon-edit" style="margin-left: 3px" slot="reference"></el-link>
          </el-popover>
        </template>
      </el-table-column>
      <el-table-column
        prop="sale"
        label="销量"
        align="center"
        width="120">
      </el-table-column>
      <el-table-column
        prop="left"
        label="余量"
        align="center"
        width="120">
        <template v-slot="scope">
          {{scope.row.total - scope.row.sale}}
        </template>
      </el-table-column>
      <el-table-column
        prop="other"
        label=""
        align="center"
        width="120">
        <template v-slot="scope">
          <el-row style="text-align: center">
            <el-button round type="primary" size="small" @click="getCommodityDetails(scope.row.id)">查看详情</el-button>
          </el-row>
          <el-row style="text-align: center; margin-top: 10px">
            <el-button round type="danger" size="small" @click="deleteCommodity(scope.row.id)">删除商品</el-button>
          </el-row>
        </template>
      </el-table-column>
    </el-table>

    <!--抽屉-->
    <el-drawer
      title="商品详情"
      :visible.sync="drawer"
      direction="rtl">
      <!--商品图片-->
      <img :src="curCommodityDetails.img_url" style="width: 100%" alt="">
      <!--商品介绍-->
      <h3 style="margin-left: 10px">商品介绍</h3><br>
      <div style="margin-bottom: 10px; margin-left: 10px">
        {{curCommodityDetails.introduction}}
      </div>
      <!--商品详情-->
      <h3 style="margin-left: 10px; margin-top: 50px">商品详情</h3><br>
      <el-descriptions :column="2"  border>
        <el-descriptions-item :span="2">
          <template slot="label">
            商品名称
          </template>
          {{curCommodityDetails.name}}
        </el-descriptions-item>
        <el-descriptions-item>
          <template slot="label">
            价格
          </template>
          {{curCommodityDetails.price}}
        </el-descriptions-item>
        <el-descriptions-item>
          <template slot="label">
            优惠
          </template>
          {{curCommodityDetails.discount}}
        </el-descriptions-item>
        <el-descriptions-item>
          <template slot="label">
            折后
          </template>
          {{formatPrice(curCommodityDetails.price, curCommodityDetails.discount, 0)}}
        </el-descriptions-item>
        <el-descriptions-item>
          <template slot="label">
            总量
          </template>
          {{curCommodityDetails.total}}
        </el-descriptions-item>
        <el-descriptions-item>
          <template slot="label">
            销量
          </template>
          {{curCommodityDetails.sale}}
        </el-descriptions-item>
        <el-descriptions-item>
          <template slot="label">
            余量
          </template>
          {{curCommodityDetails.total - curCommodityDetails.sale}}
        </el-descriptions-item>
        <el-descriptions-item>
          <template slot="label">
            交易方式
          </template>
          <el-tag v-if="curCommodityDetails.method === 0" type="success" effect="plain"><strong>线上交易</strong></el-tag>
          <el-tag v-if="curCommodityDetails.method === 1" type="primary" effect="plain"><strong>线下自取</strong></el-tag>
          <el-tag v-if="curCommodityDetails.method === 2" type="warning" effect="plain"><strong>送货上门</strong></el-tag>
        </el-descriptions-item>
        <el-descriptions-item>
          <template slot="label">
            商品状态
          </template>
          <el-tag v-if="curCommodityDetails.status === 0" type="primary"><strong>未生效</strong></el-tag>
          <el-tag v-if="curCommodityDetails.status === 1" type="warning"><strong>预售中</strong></el-tag>
          <el-tag v-if="curCommodityDetails.status === 2" type="success"><strong>售卖中</strong></el-tag>
          <el-tag v-if="curCommodityDetails.status === 3" type="info"><strong>已下架</strong></el-tag>
        </el-descriptions-item>
      </el-descriptions>
      <br><br>
      <!--商品具体参数-->
      <template v-if="curCommodityDetails.parameters !== []">
        <h3 style="margin-left: 10px">商品参数</h3><br>
        <el-descriptions :column="1"  border>
          <el-descriptions-item v-for="item in curCommodityDetails.parameters" :key="item.id">
            <template slot="label">
              {{item.name}}
            </template>
            <el-tag v-for="(option, index) in item.options" :key="option.id" :type="tagTypes[index % 4]" style="margin-right: 10px" >
              {{`${option.description}(¥${formatPrice(curCommodityDetails.price, curCommodityDetails.discount, option.add)})`}}
            </el-tag>
          </el-descriptions-item>
        </el-descriptions>
      </template>
      <!--修改商品信息-->
      <!--<el-row style="text-align: center">-->
      <!--  <el-button type="warning" size="small" style="margin-top: 50px" @click="goToUpdateCommodity">修改商品信息</el-button>-->
      <!--</el-row>-->
    </el-drawer>
  </d2-container>
</template>

<script>
import api from '@/api'

export default {
  name: 'shop-goods',
  data () {
    return {
      newStatus: '',
      newDiscount: '',
      tagTypes: ['success', 'primary', 'warning', 'danger'],
      drawer: false,
      select: 0,
      userId: this.$store.state.d2admin.user.info.id,
      shopList: [],
      curShopId: 0,
      curCommodityList: [],
      curCommodityDetails: {}
    }
  },
  methods: {
    /**
     * 获得商铺列表
     */
    async getShopList () {
      const res = await api.GET_USER_SHOP_LIST(this.userId)
      this.shopList = res.owner_shop.concat(res.admin_shop)
    },
    /**
     * 获得商品列表
     */
    async getCommodityList () {
      const res = await api.GET_COMMODITY_LIST_FOR_SHOP(this.curShopId, 1, { keyword: '' })
      this.curCommodityList = res.data
      console.log(this.curCommodityList)
    },
    /**
     * 获得某商品的详情
     */
    async getCommodityDetails (commodityId) {
      const res = await api.GET_COMMODITY_DETIALS(commodityId)
      console.log(res)
      this.curCommodityDetails = res
      this.drawer = true
    },
    /**
     * 删除某个商品
     */
    async deleteCommodity (commodityId) {
      await this.$confirm('此操作将永久删除该商品, 是否继续?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      })
      await api.DELETE_COMMODITY(commodityId)
      await this.getCommodityList()
      this.$Message.success('删除成功！')
    },
    /**
     * 跳转到创建商品的页面
     */
    goToCreateCommodity () {
      this.$router.push({
        name: 'commodity-create',
        query: { shopId: this.curShopId }
      })
    },
    /**
     * 跳转到更新商品的页面
     */
    goToUpdateCommodity () {
      this.$router.push({
        name: 'commodity-update',
        query: { shopId: this.curShopId }
      })
    },
    /**
     * 修改商品状态
     */
    async changeStatus (commodityId) {
      await api.UPDATE_COMMODITY_DETAILS(commodityId, { status: this.newStatus })
      await this.getCommodityList()
      this.$Message.success('修改成功！')
    },
    /**
     * 修改商品折扣
     */
    async changeDiscount (commodityId) {
      if (!/^[0-9]+\.[0-9]{2}$/.test(this.newDiscount)) {
        this.$Message.error('必须输入两位小数！')
      } else {
        await api.UPDATE_COMMODITY_DETAILS(commodityId, { discount: this.newDiscount })
        await this.getCommodityList()
        this.$Message.success('修改成功！')
      }
    },
    /**
     * 根据原价格、折扣、参数加成计算总价格
     */
    formatPrice (oriPrice, discount, addition) {
      return (parseFloat(oriPrice) - parseFloat(discount) + parseFloat(addition)).toFixed(2)
    }
  },
  watch: {
    curShopId: {
      handler (newVal) {
        this.getCommodityList()
      }
    }
  },
  mounted () {
    this.getShopList()
      .then(() => {
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
