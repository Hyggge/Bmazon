<template>
  <d2-container>
    <!--进度条-->
    <template v-slot:header>
      <el-steps
        :space="200"
        :active="curStep"
        finish-status="success"
        align-center>
        <el-step title="基本信息"></el-step>
        <el-step title="商品参数"></el-step>
        <el-step title="商品图片"></el-step>
        <el-step title="商品介绍"></el-step>
      </el-steps>
    </template>
    <!--标签页-->
    <el-tabs tab-position="left" @tab-click="handleTabChange">
      <!--商品基本信息-->
      <el-tab-pane label="基本信息" name="0">
        <el-form ref="form1" :model="form" label-width="80px" style="width: 80%; margin-left: 20px">
          <el-form-item label="商品名称" prop="name" :rules="rules.name">
            <el-input v-model.trim="form.name" ></el-input>
          </el-form-item>
          <el-form-item label="商品价格" prop="price" :rules="rules.price">
            <el-input v-model.trim="form.price"></el-input>
          </el-form-item>
          <el-form-item label="商品折扣" prop="discount" :rules="rules.discount">
            <el-input v-model.trim="form.discount"></el-input>
          </el-form-item>
          <el-form-item label="商品总量" prop="total" :rules="rules.total">
            <el-input v-model.trim="form.total"></el-input>
          </el-form-item>
          <el-form-item label="交易方式" prop="method" :rules="rules.method">
            <el-radio v-model="form.method" :label="0">线上交易</el-radio>
            <el-radio v-model="form.method" :label="1">线下自取</el-radio>
            <el-radio v-model="form.method" :label="2">送货上门</el-radio>
          </el-form-item>
          <el-form-item label="商品状态" prop="status" :rules="rules.status">
            <el-select v-model="form.status" clearable placeholder="请选择">
              <el-option label="未生效" :value="0"> </el-option>
              <el-option label="预售中" :value="1"> </el-option>
              <el-option label="售卖中" :value="2"> </el-option>
            </el-select>
          </el-form-item>
        </el-form>
      </el-tab-pane>
      <!--商品参数-->
      <el-tab-pane  label="商品参数" name="1">
        <el-form ref="form2" :model="form" label-width="80px" style="width: 80%; margin-left: 20px">

          <!--循环生成参数输入框-->
          <div v-for="(para, paraIndex) in form.para_set" :key="paraIndex">
            <el-form-item label="参数名" :prop="'para_set.' +  paraIndex + '.name'" :rules="rules.paraName">
              <el-input v-model="para.name" style="width: 300px"></el-input>
              <a class="el-icon-delete" style="margin-left: 10px" @click="deletePara(paraIndex)"></a>
              <!--<a v-if="paraIndex === form.para_set.length - 1" class="el-icon-plus" style="margin-left: 10px" @click="addPara"></a>-->
            </el-form-item>
            <!--循环生成可选项输入框-->
            <el-form-item label="可选项" required>
              <row v-for="(option, optionIndex) in para.options" :key="optionIndex" style="margin-bottom: 22px">
                <!--可选项名称-->
                <el-form-item :prop="'para_set.' + paraIndex +'.options.'+ optionIndex +'.description'" :rules="rules.optionName">
                  <el-input v-model="option.description" style="width: 130px; margin-right: 10px" placeholder="请输入选项名称" > </el-input>
                </el-form-item>
                <!--可选项对应价格-->
                <el-form-item :prop="'para_set.' + paraIndex +'.options.'+ optionIndex +'.price'" :rules="rules.optionPrice">
                  <el-input v-model="option.price" style="width: 130px" placeholder="请输入对应价格"> </el-input>
                </el-form-item>
                <a v-if="form.para_set[paraIndex].options.length !== 1" class="el-icon-delete" style="margin-left: 10px; margin-top: 12px" @click="deleteOption(paraIndex, optionIndex)"></a>
                <a v-if="optionIndex === form.para_set[paraIndex].options.length - 1" class="el-icon-plus" style="margin-left: 10px; margin-top: 12px" @click="addOption(paraIndex)"></a>
              </row>
            </el-form-item>
            <hr style="margin-bottom: 20px">
          </div>
          <!--生成参数的按钮-->
          <el-button type="primary" @click="addPara"> 增加参数 </el-button>
        </el-form>
      </el-tab-pane>
      <!--商品图片 TODO:商品图片有可能有多个-->
      <el-tab-pane label="商品图片" name="2">
        <el-form ref="form3" :model="form" label-width="80px" style="width: 80%; margin-left: 20px">
          <el-form-item label="上传图片" prop="image_id" :rules="rules.image">
            <!--上传多个图片-->
            <el-upload
              class="upload-demo"
              action="/api/file/upload"
              list-type="picture"
              :headers="{Authorization: 'Bearer ' + token}"
              :on-success="handleUploadSuccess"
              :before-upload="beforeImageUpload"
              :file-list="[]">
              <el-button size="small" type="primary">点击上传</el-button>
              <div slot="tip" class="el-upload__tip">只能上传jpg/png文件，且不超过500kb</div>
            </el-upload>
            <!--上传单个图片-->
            <!--<el-upload-->
            <!--  class="avatar-uploader"-->
            <!--  action="/api/file/upload"-->
            <!--  :show-file-list="false"-->
            <!--  :headers="{Authorization: 'Bearer ' + token}"-->
            <!--  :on-success="handleUploadSuccess">-->
            <!--  <img v-if="imageUrl" :src="imageUrl" class="avatar">-->
            <!--  <i v-else class="el-icon-plus avatar-uploader-icon"></i>-->
            <!--</el-upload>-->
          </el-form-item>
        </el-form>
      </el-tab-pane>
      <!--商品介绍-->
      <el-tab-pane label="商品介绍" name="3">
        <el-form ref="form4" :model="form" label-width="80px" style="width: 80%; margin-left: 20px">
          <el-form-item label="商品介绍" prop="introduction" :rules="rules.introduction">
            <el-input
              type="textarea"
              :rows="6"
              placeholder="请输入内容"
              v-model.trim="form.introduction">
            </el-input>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" @click="onSubmit">立即创建</el-button>
          </el-form-item>
        </el-form>
      </el-tab-pane>
    </el-tabs>
  </d2-container>
</template>

<script>
import util from '@/libs/util.js'
import api from '@/api'

export default {
  name: 'commodity-create',
  data () {
    return {
      curStep: 0,
      curShopId: 0,
      imageUrl: '',
      token: util.cookies.get('token'),
      form: {
        name: '',
        total: '',
        price: '',
        discount: '',
        method: 0,
        introduction: '',
        status: 2,
        image_id: [],
        para_set: [
          // item
          // {
          //   name: '',
          //   options: [
          //     // para
          //     { description: '', price: '' }
          //   ]
          // }
        ]
      },
      rules: {
        name: [{ required: true, message: '请输入商品名称', trigger: 'blur' }],
        price: [{ required: true, message: '请输入价格', trigger: 'blur' }, { validator: this.checkPrice, trigger: 'blur' }],
        discount: [{ required: true, message: '请输入商品优惠', trigger: 'blur' }, { validator: this.checkPrice, trigger: 'blur' }],
        total: [{ required: true, message: '请输入商品总量', trigger: 'blur' }, { validator: this.checkTotal, trigger: 'blur' }],
        method: [{ required: true, message: '请输入交易方式', trigger: 'blur' }],
        status: [{ required: true, message: '请输入商品状态', trigger: 'blur' }],
        paraName: [{ required: true, message: '参数名不能为空', trigger: 'blur' }],
        optionName: [{ required: true, message: '选项名称不能为空', trigger: 'blur' }],
        optionPrice: [{ required: true, message: '对应价格不能为空', trigger: 'blur' }, { validator: this.checkPrice, trigger: 'blur' }],
        image: [{ required: true, message: '图片不能为空', trigger: 'blur' }],
        introduction: [{ required: true, message: '商品介绍不能为空', trigger: 'blur' }]
      }
    }
  },
  methods: {
    /**
     * 提交表单
     */
    async onSubmit () {
      // 检查表单数据是否合法
      let valid = true
      for (const form of ['form1', 'form2', 'form3', 'form4']) {
        this.$refs[form].validate((value) => {
          valid &= value
        })
      }
      if (!valid) {
        this.$Message.error('表单输入不合法！')
      }
      console.log(this.form)
      // 构造请求数据
      const data = JSON.parse(JSON.stringify(this.form))
      data.para_set.forEach((para, paraIndex) => {
        const map = {}
        para.options.forEach((option, optionIndex) => {
          map[option.description] = ((parseFloat(option.price) - parseFloat(data.price))).toFixed(2) + ''
        })
        para.options = map
      })
      console.log(data)
      // 发送请求
      const res = await api.ADD_COMMODITY(this.curShopId, data)
      console.log(res)
      this.$Message.success('创建成功！')
      await this.$router.push({ path: '/shop/goods' })
    },
    /**
     * 获取已上传图片的id
     */
    handleUploadSuccess (res, file) {
      if (res.id !== null) {
        this.imageUrl = URL.createObjectURL(file.raw)
        this.form.image_id.push(res.id)
        console.log(this.form.image_id)
      }
    },
    /**
     * 当标签页更改修改页面上方流程图的step
     */
    handleTabChange (tab, event) {
      this.curStep = parseInt(tab.name)
    },
    /**
     * 增加参数
     */
    addPara () {
      this.form.para_set.push({
        name: '',
        options: [{ description: '', price: '' }]
      })
    },
    /**
     * 删除参数
     */
    deletePara (paraIndex) {
      this.form.para_set =
        this.form.para_set.filter((value, index) => { return index !== paraIndex })
    },
    /**
     * 增加可选项
     */
    addOption (paraIndex) {
      this.form.para_set[paraIndex].options.push(
        { description: '', price: '' }
      )
    },
    /**
     * 删除可选项
     */
    deleteOption (paraIndex, optionIndex) {
      this.form.para_set[paraIndex].options =
        this.form.para_set[paraIndex].options.filter((value, index) => { return index !== optionIndex })
    },
    /**
     * 验证价格是否合法
     */
    checkPrice (rule, value, callback) {
      const regExp = /^[0-9]+([.][0-9]{0,2})?$/
      if (!regExp.test(value)) {
        callback(new Error('输入数字不合法（必须为整数、1位小数或2位小数）'))
      } else {
        callback()
      }
    },
    /**
     * 验证总数是否合法
     */
    checkTotal (rule, value, callback) {
      const regExp = /^[0-9]+$/
      if (!regExp.test(value)) {
        callback(new Error('必须输入整数'))
      } else {
        callback()
      }
    },
    /**
     * 检查用户上传图片的格式和大小
     */
    beforeImageUpload (file) {
      const isJPG = (file.type === 'image/jpeg') || (file.type === 'image/png')
      const isLt2M = file.size / 1024 / 1024 < 2
      if (!isJPG) {
        this.$Message.error('上传图片只能是 JPG/PNG 格式!')
      }
      if (!isLt2M) {
        this.$Message.error('上传图片大小不能超过 2MB!')
      }
      return isJPG && isLt2M
    }
  },
  mounted () {
    this.curShopId = this.$route.query.shopId
  }
}
</script>

<style scoped>

</style>
