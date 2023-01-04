<template>
  <d2-container>
     <template v-slot:header>
        <el-row >
          <el-col style="text-align: center">
            <el-avatar style="margin-left: 10px;" :size="150" :src="headImg"></el-avatar>
          </el-col>
        </el-row>
         <el-row>
           <el-col style="text-align: center">
             <h2 style="text-align:center">{{auth.username}}</h2>
           </el-col>
           <el-col :span="3" :offset="19"  style="margin-top: -30px;">
             <el-button  size="mini" type="primary" @click="openFormForUpdate">个人信息修改</el-button>
           </el-col>
           <el-col :span="3" :offset="22" style="margin-top: -30px;">
             <el-upload
               style=" width: 100%"
               class="upload-demo"
               :headers="{Authorization: 'Bearer ' + token}"
               :on-success="handleUploadSuccess"
               :on-error="handleUploadError"
               :before-upload="beforeImageUpload"
               :show-file-list="false"
               :action="`/api/images`">
               <el-button size="mini"  type="success" >上传新头像</el-button>
             </el-upload>
           </el-col>
         </el-row>

     </template>

    <el-collapse :value="['1', '2']">
      <el-collapse-item title="基本信息" name="1">
        <el-descriptions class="margin-top"  :column="2"  border>
          <el-descriptions-item>
            <template slot="label">
              <i class="el-icon-user"></i>
              用户名
            </template>
            {{userInfo.username}}
          </el-descriptions-item>
          <el-descriptions-item>
            <template slot="label">
              <i class="el-icon-location-outline"></i>
              身份
            </template>
            {{userInfo.role == 0 ? '管理员' : '普通用户'}}
          </el-descriptions-item>
          <el-descriptions-item>
            <template slot="label">
              <i class="el-icon-location-outline"></i>
              居住地
            </template>
            北京市
          </el-descriptions-item>
          <el-descriptions-item>
            <template slot="label">
              <i class="el-icon-mobile-phone"></i>
              手机号
            </template>
            {{userInfo.phone_no}}
          </el-descriptions-item>
          <el-descriptions-item>
            <template slot="label">
              <i class="el-icon-message"></i>
              电子邮箱
            </template>
            {{userInfo.email}}
          </el-descriptions-item>
          <el-descriptions-item>
            <template slot="label">
              <i class="el-icon-watch"></i>
              注册时间
            </template>
            {{userInfo.reg_time.slice(0, userInfo.reg_time.indexOf('T'))}}
          </el-descriptions-item>
          <el-descriptions-item>
            <template slot="label">
              <i class="el-icon-office-building"></i>
              个性签名
            </template>
            {{userInfo.signature ? userInfo.signature : '暂未设置'}}
          </el-descriptions-item>
        </el-descriptions>
      </el-collapse-item>
      <!--学生认证-->
      <el-collapse-item
        :title="`学生认证`"
        name="2">
        <!--如果进行了认证-->
        <template v-if="userInfo.status === 1">
          <el-descriptions class="margin-top"  :column="2"  border>
            <!--学号-->
            <el-descriptions-item>
              <template slot="label">
                <i class="el-icon-office-building"></i>
                学号
              </template>
              {{userInfo.student_info.id}}
            </el-descriptions-item>
            <!--学生姓名-->
            <el-descriptions-item>
              <template slot="label">
                <i class="el-icon-office-building"></i>
                学生姓名
              </template>
              {{userInfo.student_info.name}}
            </el-descriptions-item>
            <!--学生性别-->
            <el-descriptions-item>
              <template slot="label">
                <i class="el-icon-office-building"></i>
                学生性别
              </template>
              {{userInfo.student_info.gender === 0 ? '男' : '女'}}
            </el-descriptions-item>
            <!--学生入学年份-->
            <el-descriptions-item>
              <template slot="label">
                <i class="el-icon-office-building"></i>
                入学年份
              </template>
              {{userInfo.student_info.attendance_year}}
            </el-descriptions-item>
            <!--学生院系-->
            <el-descriptions-item>
              <template slot="label">
                <i class="el-icon-office-building"></i>
                学生院系
              </template>
              {{getDepartNameById(userInfo.student_info.depart)}}
            </el-descriptions-item>
          </el-descriptions>
        </template>
        <!--如果没有进行认证-->
        <template v-else>
          <el-button type="primary" @click="certificate" >点击这里进行认证</el-button>
        </template>
      </el-collapse-item>
    </el-collapse>

    <!--用户信息修改-->
    <Modal
      v-model="modalForUpdate"
      title="修改个人信息"
      @on-ok="updateUserInfo">
      <el-form ref="form" :model="form" label-width="80px">
        <el-form-item label="邮箱" prop="email" :rules="rules.email">
          <el-input v-model.trim="form.email"></el-input>
        </el-form-item>
        <el-form-item label="个性签名" prop="signature" :rules="rules.signature">
          <el-input v-model.trim="form.signature"></el-input>
        </el-form-item>
        <el-form-item label="手机号" prop="phone_no" :rules="rules.phone_no">
          <el-input v-model.trim="form.phone_no"></el-input>
        </el-form-item>
      </el-form>
    </Modal>

  </d2-container>
</template>

<script>
import { mapState } from 'vuex'
import { getDepartNameById } from '@/libs/util.depart'
import api from '@/api'
import util from '@/libs/util'

export default {
  name: 'user-details',
  computed: {
    ...mapState('d2admin/user', {
      auth: 'info'
    }),
    headImg () {
      if (this.userInfo.image_url == null) {
        return 'https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png'
      } else {
        return this.userInfo.image_url
      }
    }
  },
  data () {
    return {
      token: util.cookies.get('token'),
      drawer: false,
      modalForUpdate: false,
      userInfo: {},
      form: {
        phone_no: '',
        email: '',
        signature: ''
      },
      rules: {
        email: [{ required: true, message: '请输入邮箱', trigger: 'blur' }, { validator: this.checkEmail, trigger: 'blur' }],
        signature: [{}],
        phone_no: [{ validator: this.checkPhoneNo, trigger: 'blur' }]
      }
    }
  },
  methods: {
    formatTime: util.time.formatTime,
    /**
     * 通过院系号码获得院系名称
     */
    getDepartNameById,
    /**
     * 获得用户具体信息
     */
    getUserInfo () {
      api.GET_USER_INFO(this.auth.id)
        .then((res) => {
          console.log(res)
          this.userInfo = res
        })
        .catch((err) => {
          console.log(err)
        })
    },
    /**
     * 打开修改个人信息的表单
     */
    openFormForUpdate () {
      this.modalForUpdate = true
      this.form.nickname = this.userInfo.nickname
      this.form.email = this.userInfo.email
      this.form.signature = this.userInfo.signature === null ? '' : this.userInfo.signature
      this.form.phone_no = this.userInfo.phone_no === null ? '' : this.userInfo.phone_no
    },
    /**
     * 检查新邮箱是否合法
     */
    checkEmail (rule, value, callback) {
      const pattern =
        /^[a-zA-Z0-9]+([-_.][A-Za-zd]+)*@([a-zA-Z0-9]+[-.])+[A-Za-zd]{2,5}$/
      if (!pattern.test(value)) {
        callback(new Error('邮箱格式不合法'))
      } else {
        callback()
      }
    },
    /**
     * 检查新手机号是否合法
     */
    checkPhoneNo (rule, value, callback) {
      if (value.length === 0) callback()
      const pattern = /^(13[0-9]|14[01456879]|15[0-35-9]|16[2567]|17[0-8]|18[0-9]|19[0-35-9])\d{8}$/
      if (!pattern.test(value)) {
        callback(new Error('手机号格式不合法'))
      } else {
        callback()
      }
    },
    /**
     * 修改个人信息
     */
    async updateUserInfo () {
      // 检查表单数据是否合法
      let valid = true
      this.$refs.form.validate((value) => {
        valid = value
      })
      if (!valid) {
        this.$Message.error('表单输入不合法')
        return
      }
      // 发送请求
      await api.UPDATE_USER_INFO(this.userInfo.id, this.form)
      await this.getUserInfo()
      this.$Message.success('修改成功！')
    },
    /**
     * 用户发出认证申请
     */
    certificate () {
      this.$router.push({ name: 'user-certificate' })
    },
    /**
     * 上传新头像
     */
    async handleUploadSuccess (res, file) {
      await api.SET_USER_HEAD_IMG(res.id)
      this.$store.state.d2admin.user.info.headImg = await api.DOWNLOAD_IMAGE(res.id)
      this.$Message.success('上传成功！')
      this.getUserInfo()
    },
    handleUploadError (res, file) {
      this.$Message.error('上传失败！')
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
    this.getUserInfo()
  }
}
</script>

<style scoped>

</style>
