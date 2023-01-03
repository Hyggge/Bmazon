<template>
  <d2-container>
    <template v-slot:header>
      <h3>创建店铺</h3>
    </template>
    <el-row>
      <el-col :span="12" :offset="4" label-width="80px">
        <el-form ref="form" :model="form" label-width="80px">
          <el-form-item label="店铺名" required>
            <el-input v-model.trim="form.name"></el-input>
          </el-form-item>
          <el-form-item label="类型" required>
            <el-radio v-model="form.type" :label="0">个人店铺</el-radio>
            <el-radio v-model="form.type" :label="1">合作店铺</el-radio>
          </el-form-item>
          <el-form-item label="店铺介绍">
            <el-input
              type="textarea"
              :rows="4"
              placeholder="请输入内容"
              v-model.trim="form.introduction">
            </el-input>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" @click="onSubmit">立即创建</el-button>
          </el-form-item>
        </el-form>
      </el-col>
    </el-row>
  </d2-container>
</template>

<script>
import api from '@/api'

export default {
  name: 'shop-create',
  data () {
    return {
      form: {
        name: '',
        introduction: '',
        type: 0
      }
    }
  },
  methods: {
    onSubmit () {
      // 检查表单项是否为空
      if (this.form.name === '') {
        this.$Message.error('店铺名不能为空！')
        return
      }
      // 发起创建店铺请求
      api.CREATE_NEW_SHOP(this.form)
        .then((res) => {
          console.log(res)
          this.$Message.success('创建成功！')
          this.$router.push('/shop/details')
        })
        .catch((err) => {
          if (err.response.data.error_msg === 'ErrorCode.INVALID_REQUEST_ARGS: 需要先进行学生认证才能开店') {
            this.$Message.error('需要先进行学生认证才能开店')
          }
        })
    }
  }
}
</script>

<style scoped>

</style>
