<template>
  <d2-container>
    <template v-slot:header>
      <h3>学生认证</h3>
    </template>
    <el-row>
      <el-col :span="12" :offset="4" label-width="80px">
        <el-form ref="form" :model="form" label-width="80px">
          <el-form-item label="学号" required>
            <el-input v-model.trim="form.student_id" @blur="checkDupStudentId"></el-input>
          </el-form-item>
          <el-form-item label="姓名" required>
            <el-input v-model.trim="form.student_name"></el-input>
          </el-form-item>
          <el-form-item label="性别" required>
            <el-radio v-model="form.gender" :label="0">男</el-radio>
            <el-radio v-model="form.gender" :label="1">女</el-radio>
          </el-form-item>
          <el-form-item label="入学年份" required>
            <el-date-picker
              style="width: 100%"
              v-model="form.attendance_year"
              value-format="yyyy"
              type="year"
              placeholder="选择年">
            </el-date-picker>
          </el-form-item>
          <el-form-item label="院系" required>
            <el-select v-model="form.depart" placeholder="请选择" style="width: 100%">
              <el-option
                v-for="item in options"
                :key="item.value"
                :label="item.label"
                :value="item.value">
              </el-option>
            </el-select>
          </el-form-item>
          <el-form-item label="上传图片" required>
            <el-upload
              class="avatar-uploader"
              action="/api/file/upload"
              :show-file-list="false"
              :headers="{Authorization: 'Bearer ' + token}"
              :on-success="handleUploadSuccess"
              :before-upload="beforeImageUpload">
              <img v-if="imageUrl" :src="imageUrl" style="width: 100%" class="avatar" />
              <i v-else class="el-icon-plus avatar-uploader-icon"></i>
            </el-upload>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" @click="onSubmit">立即认证</el-button>
          </el-form-item>
        </el-form>

      </el-col>
    </el-row>
  </d2-container>
</template>

<script>
import api from '@/api'
import util from '@/libs/util.js'
import { departList } from '@/libs/util.depart'

export default {
  name: 'user-certificate',
  data () {
    return {
      imageUrl: '',
      token: util.cookies.get('token'),
      form: {
        student_id: '',
        student_name: '',
        depart: 1,
        attendance_year: '2022',
        gender: 0,
        image_id: ''
      },
      valid: true,
      options: departList
    }
  },
  methods: {
    /**
     * 提交认证请求
     */
    onSubmit () {
      // 检查表单项是否为空
      if (this.form.student_id === '' || this.form.student_name === '' || this.form.image_id === '') {
        this.$Message.error('表单项不能为空')
        this.valid = false
      }
      // 检查学号是否重复
      this.checkDupStudentId(this.form.student_id)
      // 发起认证请求
      if (this.valid) {
        api.SUBMIT_USER_CERTIFICATE(this.form)
          .then((res) => {
            this.$Message.success('提交成功！')
            this.$router.push({ path: '/user/details' })
          })
          .catch((err) => {
            console.log(err)
          })
      }
    },
    /**
     * 检查用户输入的学号是否已经被认证过
     */
    checkDupStudentId () {
      api.CHECK_DUP_STUDENT_ID(this.form.student_id)
        .then((res) => {
          if (res.exist === true) {
            this.valid = false
            this.$Message.error('该学号已被认证过')
          } else {
            this.valid = true
          }
        })
        .catch((err) => {
          console.log(err)
        })
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
    },
    /**
     * 上传图片成功后记录image_id
     */
    handleUploadSuccess (res, file) {
      if (res.id !== null) {
        this.imageUrl = URL.createObjectURL(file.raw)
        this.form.image_id = res.id
      }
    }
  }
}
</script>

<style scoped>

</style>
