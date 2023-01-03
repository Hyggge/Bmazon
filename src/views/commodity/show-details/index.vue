<template>
  <d2-container>
    <!--<template v-slot:header>-->
    <!--  <h2>{{commodityDetails.name}}</h2>-->

    <!--</template>-->
    <el-row style="margin-top: 10px">
      <el-col :span="9" :offset="1">
        <img :src="commodityDetails.img_url" style="border-radius: 20px; width: 100%">
      </el-col>
      <el-col :span="12" :offset="1" style="margin-top: 15px">
        <!--商品介绍-->
        <h3 style="color: black">
          {{commodityDetails.name + ": " + commodityDetails.introduction}}
        </h3>
        <!--商品销售-->
        <h5 style="color: lightslategray">
          已售 {{commodityDetails.sale}}
        </h5>
        <!--价格-->
        <h1 style="color: #ff8226; padding-top: 10px">
          <span style="font-size: 12px">¥</span>
          {{this.curPrice}}
        </h1>
        <!--<hr>-->
        <!--商品余量-->
        <el-row class="term">
          <el-col class="title" :span="3"> 商品余量:</el-col>
          <el-col class="content" :span="20">
            {{commodityDetails.total - commodityDetails.sale}}
          </el-col>
        </el-row>
        <!--商品评价-->
        <el-row class="term">
          <el-col class="title" :span="3"> 商品评分:</el-col>
          <el-col class="content" :span="20">
            <el-rate v-if="commodityDetails.grade !== null"
              v-model="commodityDetails.grade"
              disabled
              show-score
              text-color="#ff9900"
              score-template="{value}">
            </el-rate>
            <div v-else>暂无评分</div>
          </el-col>
        </el-row>
        <!--交易方式-->
        <el-row class="term">
          <el-col class="title" :span="3"> 交易方式:</el-col>
          <el-col class="content" :span="20">
            <el-tag v-if="commodityDetails.method === 0" type="success" size="mini"><strong>线上交易</strong></el-tag>
            <el-tag v-if="commodityDetails.method === 1" type="primary" size="mini"><strong>线下自取</strong></el-tag>
            <el-tag v-if="commodityDetails.method === 2" type="warning" size="mini"><strong>送货上门</strong></el-tag>
          </el-col>
        </el-row>
        <!--商品状态-->
        <el-row class="term">
          <el-col class="title" :span="3"> 商品状态:</el-col>
          <el-col class="content" :span="20">
            <el-tag v-if="commodityDetails.status === 0" type="primary" size="mini"><strong>未生效</strong></el-tag>
            <el-tag v-if="commodityDetails.status === 1" type="warning" size="mini"><strong>预售中</strong></el-tag>
            <el-tag v-if="commodityDetails.status === 2" type="success" size="mini"><strong>售卖中</strong></el-tag>
            <el-tag v-if="commodityDetails.status === 3" type="info" size="mini"><strong>已下架</strong></el-tag>
          </el-col>
        </el-row>
        <!--商品属性-->
        <el-row class="term" v-for="(param, paramIndex) in commodityDetails.parameters" :key="param.id">
          <el-col class="title" :span="3"> {{param.name}}:</el-col>
          <el-col class="content" :span="20">
            <el-radio-group v-model="selectedOptions[paramIndex]" size="mini">
              <el-radio v-for="option in param.options" :key="option.id"
                        style="margin-right: 10px;"
                        @change="onClickOption(paramIndex, option.add)"
                        :label="option.id" border>
              {{option.description}}
              </el-radio>
            </el-radio-group>
          </el-col>
        </el-row>
        <!--数量选择框-->
        <el-row class="term">
          <el-col class="title" :span="3" style="padding-top: 6px"> 数量:</el-col>
          <el-col class="content" :span="20">
            <el-input-number v-model="form.num"
                             @change="onClickCounter"
                             :max="commodityDetails.total - commodityDetails.sale"
                             :min="1" size="mini"></el-input-number>
          </el-col>
        </el-row>
        <!--下单按钮-->
        <el-button type="danger" round style="margin-top: 20px"
                   @click="openModal">立即下单</el-button>
        <el-button type="primary" round style="margin-top: 20px"
                   @click="copyLink">复制链接</el-button>
<!--        <el-button v-if="articleDetails.collect" circle size="mini" @click="cancelCollect">-->
<!--          <img src="../../../assets/img/collected.svg" alt= "" style="width: 10px">-->
<!--        </el-button>-->
<!--        <el-button v-else circle size="mini" @click="clickCollect">-->
<!--          <img src="../../../assets/img/not-collected.svg" alt= "" style="width: 10px">-->
<!--        </el-button>-->
      </el-col>
    </el-row>
    <!--用户评论-->
    <el-tabs v-model="curPane">
      <el-tab-pane label="用户评价" name="comments">
        <comments :commodityId="commodityId"></comments>
      </el-tab-pane>
      <el-tab-pane label="商品预览图" name="otherImages">
        <!--<div>-->
        <!--  <img :src="commodityDetails.img_url" alt="" style="width: 80%; text-align: center">-->
        <!--</div>-->
        <!--<div v-for="url in commodityDetails.img_url_list">-->
        <!--  <img :src="url" alt="" style="width: 80%; text-align: center">-->
        <!--</div>-->
        <el-row :gutter="30">
          <el-col :span="6" style="margin-bottom: 20px" >
            <div>
              <img :src="commodityDetails.img_url" alt="" style="width: 100%; height: 100%">
            </div>
          </el-col>
          <div v-for="url in commodityDetails.img_url_list">
            <el-col :span="6" style="margin-bottom: 20px" >
              <div>
                <img :src="url" style="width: 100%; height: 100%">
              </div>
            </el-col>
          </div>
        </el-row>
      </el-tab-pane>
    </el-tabs>

    <!--下单对话框-->
    <Modal
      v-model="modal"
      title="请确认订单信息"
      @on-ok="submitOrder"
      @on-cancel="$Message.error('取消下单')">
      <el-descriptions class="margin-top" :column="2" :size="size" border>
        <!--购买数量-->
        <el-descriptions-item>
          <template slot="label">
            购买数量
          </template>
          {{form.num}}
        </el-descriptions-item>
        <!--总价格-->
        <el-descriptions-item>
          <template slot="label">
            总价格
          </template>
          {{'¥' + curPrice}}
        </el-descriptions-item>
        <!--交易方式-->
        <el-descriptions-item>
          <template slot="label">
            交易方式
          </template>
          <el-tag v-if="commodityDetails.method === 0" type="success" size="mini"><strong>线上交易</strong></el-tag>
          <el-tag v-if="commodityDetails.method === 1" type="primary" size="mini"><strong>线下自取</strong></el-tag>
          <el-tag v-if="commodityDetails.method === 2" type="warning" size="mini"><strong>送货上门</strong></el-tag>
        </el-descriptions-item>
        <!--商品状态-->
        <el-descriptions-item>
          <template slot="label">
            商品状态
          </template>
          <el-tag v-if="commodityDetails.status === 0" type="primary" size="mini"><strong>未生效</strong></el-tag>
          <el-tag v-if="commodityDetails.status === 1" type="warning" size="mini"><strong>预售中</strong></el-tag>
          <el-tag v-if="commodityDetails.status === 2" type="success" size="mini"><strong>售卖中</strong></el-tag>
          <el-tag v-if="commodityDetails.status === 3" type="info" size="mini"><strong>已下架</strong></el-tag>
        </el-descriptions-item>
        <!--参数-->
        <el-descriptions-item :span="2" v-for="(param, paramIndex) in commodityDetails.parameters" :key="param.id">
          <template slot="label">
            {{param.name}}
          </template>
          <div v-for="option in param.options" :key="option.id">
            <el-tag v-if="option.id === selectedOptions[paramIndex]" style="margin-right: 10px" size="mini" >
              {{`${option.description}`}}
            </el-tag>
          </div>
        </el-descriptions-item>
        <!--交易地址-->
        <el-descriptions-item :span="2">
          <template slot="label">
            地址
          </template>
          <el-input v-model="form.address" placeholder="请输入交易地址（可选）"></el-input>
        </el-descriptions-item>
        <!--备注-->
        <el-descriptions-item :span="2">
          <template slot="label">
            备注
          </template>
          <el-input type="textarea" v-model="form.note" placeholder="请输入备注（可选）"></el-input>
        </el-descriptions-item>
      </el-descriptions>
    </Modal>
  </d2-container>
</template>

<script>
import api from '@/api'
import comments from '@/components/comments'

export default {
  name: 'show-commodity-details-for-user',
  components: { comments },
  data () {
    return {
      commodityId: this.$route.params.id,
      commodityDetails: {},
      selectedOptions: [],
      selectedAdditions: [],
      curPrice: 0,
      curPane: 'comments',
      modal: false,
      form: {
        num: 1,
        address: '',
        note: ''
      }
    }
  },
  methods: {
    /**
     * 获得商品的详细信息
     */
    async getCommodityDetails () {
      this.commodityDetails = await api.GET_COMMODITY_DETIALS(this.commodityId)
      this.commodityDetails.parameters.forEach(() => {
        this.selectedOptions.unshift(0)
        this.selectedAdditions.unshift(0)
      })
      this.curPrice = this.calcPrice()
      console.log(this.commodityDetails)
    },
    /**
     * 根据原价格、折扣、参数加成计算总价格
     */
    formatPrice (oriPrice, discount, addition, num) {
      return (num * (parseFloat(oriPrice) - parseFloat(discount) + parseFloat(addition))).toFixed(2)
    },
    /**
     * 计算实际价格
     */
    calcPrice () {
      let addSum = 0
      this.selectedAdditions.forEach((value, index) => {
        addSum += parseFloat(value)
      })
      return this.formatPrice(this.commodityDetails.price, this.commodityDetails.discount, addSum, this.form.num)
    },
    /**
     * 点击选项时执行
     */
    onClickOption (paramIndex, addition) {
      this.selectedAdditions[paramIndex] = addition
      this.curPrice = this.calcPrice()
    },
    /**
     * 点击计数器时执行
     */
    onClickCounter () {
      this.curPrice = this.calcPrice()
    },
    /**
     * 打开确认订单信息的对话框
     * 再打开之前先检查用户是否选择了所有的参数
     */
    openModal () {
      // 检查用户是否选择了所有的参数
      for (const value of this.selectedOptions) {
        console.log(value)
        if (value === 0) {
          this.$Message.error('参数选择不全！')
          return
        }
      }
      // 打开对话框
      this.modal = true
    },
    /**
     * 下单
     */
    submitOrder () {
      const select_paras = []
      this.selectedOptions.forEach((value, index) => {
        if (value !== 0) select_paras.push(value)
      })
      Object.assign(this.form, { select_paras })
      api.SUBMIT_ORDER(this.commodityId, this.form)
      this.$Message.success('下单成功')
    },
    /**
     * 复制当前商品链接
     */
    async copyLink () {
      await this.$copyText(window.location.href)
      this.$Message.success('已经成功复制到剪切板！')
    }
  },
  mounted () {
    this.getCommodityDetails()
  }
}
</script>

<style scoped>
  .term {
    padding-top: 15px;
  }

  .title {
    color: lightslategray;
    font-size: 12px;
    font-weight: bold;
    vertical-align: center;
  }

  .content {
    padding-left: 10px;
    font-size: 12px;
  }
</style>
