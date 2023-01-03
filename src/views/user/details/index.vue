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
               :action="`/api/file/upload`">
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
              <i class="el-icon-service"></i>
              昵称
            </template>
            {{userInfo.nickname}}
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
        :title="`学生认证(${getStatusInfo(status)})`"
        name="2">
        <!--如果进行了认证-->
        <template v-if="status === 1">
          <el-descriptions class="margin-top"  :column="2"  border>
            <!--学号-->
            <el-descriptions-item>
              <template slot="label">
                <i class="el-icon-office-building"></i>
                学号
              </template>
              {{lastReqDetails.student_id}}
            </el-descriptions-item>
            <!--学生姓名-->
            <el-descriptions-item>
              <template slot="label">
                <i class="el-icon-office-building"></i>
                学生姓名
              </template>
              {{lastReqDetails.student_name}}
            </el-descriptions-item>
            <!--学生性别-->
            <el-descriptions-item>
              <template slot="label">
                <i class="el-icon-office-building"></i>
                学生性别
              </template>
              {{lastReqDetails.gender === 0 ? '男' : '女'}}
            </el-descriptions-item>
            <!--学生入学年份-->
            <el-descriptions-item>
              <template slot="label">
                <i class="el-icon-office-building"></i>
                入学年份
              </template>
              {{lastReqDetails.attendance_year}}
            </el-descriptions-item>
            <!--学生院系-->
            <el-descriptions-item>
              <template slot="label">
                <i class="el-icon-office-building"></i>
                学生院系
              </template>
              {{getDepartNameById(lastReqDetails.depart)}}
            </el-descriptions-item>
          </el-descriptions>
        </template>
        <!--如果没有进行认证-->
        <template v-else>
          <el-button type="primary" @click="certificate" v-if="status !== 0">点击这里进行认证</el-button>
          <el-button type="warning" @click="drawer = true">查看历史请求记录</el-button>
        </template>
      </el-collapse-item>
    </el-collapse>

    <el-drawer
      title="历史认证记录"
      :visible.sync="drawer"
      direction="rtl">
      <el-table
        :data="reqList"
        stripe
        style="width: 100%">
        <el-table-column
          prop="req_time"
          label="申请时间"
          align="center"
          width="180">
          <template v-slot="scope">
            {{ formatTime(scope.row.req_time) }}
          </template>
        </el-table-column>
        <el-table-column
          prop="status"
          label="认证状态"
          align="center"
          width="100">
          <template v-slot="scope">
              {{getStatusInfo(scope.row.status)}}
          </template>
        </el-table-column>
        <el-table-column
          prop="details"
          align="center"
          label="详细信息">
          <template v-slot="scope">
              <el-button type="primary" size="mini" @click="getReqDetails(scope.row.id)">查看详情</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-drawer>


    <!--学生认证请求详情-->
    <Modal
      v-model="modelForCertificate"
      title="学生认证请求详情">

      <el-descriptions class="margin-top"  :column="1"  border>
        <el-descriptions-item>
          <template slot="label">
            <i class="el-icon-user"></i>
            学号
          </template>
          {{visReqDetails.student_id}}
        </el-descriptions-item>

        <el-descriptions-item>
          <template slot="label">
            <i class="el-icon-user"></i>
            姓名
          </template>
          {{visReqDetails.student_name}}
        </el-descriptions-item>

        <el-descriptions-item>
          <template slot="label">
            <i class="el-icon-user"></i>
            院系
          </template>
          {{getDepartNameById(visReqDetails.depart)}}
        </el-descriptions-item>

        <el-descriptions-item>
          <template slot="label">
            <i class="el-icon-user"></i>
            入学年份
          </template>
          {{visReqDetails.attendance_year}}
        </el-descriptions-item>

        <el-descriptions-item>
          <template slot="label">
            <i class="el-icon-user"></i>
            认证状态
          </template>
          <el-tag v-if="visReqDetails.status === 0" type="primary" size="mini" >等待审批</el-tag>
          <el-tag v-else-if="visReqDetails.status === 1" type="success" size="mini" >审批通过</el-tag>
          <el-tag v-else type="danger" size="mini" >拒绝审批</el-tag>
          <div></div>
        </el-descriptions-item>

        <el-descriptions-item v-if="visReqDetails.comment != null">
          <template slot="label">
            <i class="el-icon-user"></i>
            审批意见
          </template>
          {{visReqDetails.comment}}
        </el-descriptions-item>
      </el-descriptions>
    </Modal>

    <!--用户信息修改-->
    <Modal
      v-model="modelForUpdate"
      title="修改个人信息"
      @on-ok="updateUserInfo">
      <el-form ref="form" :model="form" label-width="80px">
        <el-form-item label="昵称" prop="nickname" :rules="rules.nickname">
          <el-input v-model.trim="form.nickname"></el-input>
        </el-form-item>
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
      if (this.userInfo.img_url == null) {
        return 'https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png'
      } else {
        return this.userInfo.img_url
      }
    }
  },
  data () {
    return {
      token: util.cookies.get('token'),
      drawer: false,
      modelForCertificate: false,
      modelForUpdate: false,
      status: 0,
      userInfo: {},
      certificateInfo: {},
      reqList: [],
      lastReqDetails: {},
      visReqDetails: {},
      form: {
        nickname: '',
        phone_no: '',
        email: '',
        signature: ''
      },
      rules: {
        nickname: [{ required: true, message: '请输入昵称', trigger: 'blur' }],
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
     * 通过status获得具体的认证状态信息
     */
    getStatusInfo (status) {
      return status === -1 ? '未认证' : status === 0 ? '等待审批' : status === 1 ? '认证成功' : '认证失败'
    },
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
     * 获得用户发出的所有请求的列表
     * 以及用户发出的最后一次请求的详细信息
     */
    async getReqList () {
      this.reqList = (await api.GET_USER_CERTIFICATE_REQ_LIST()).auth_reqs
      if (this.reqList.length > 0) { this.lastReqDetails = await api.GET_USER_CERTIFICATE_REQ_DETAIL(this.reqList[this.reqList.length - 1].id) }
      // 认证状态
      if (this.reqList.length === 0) this.status = -1
      else this.status = this.lastReqDetails.status
      console.log(this.status)
    },
    /**
     * 根据请求的ID获得响应请求的详细信息
     */
    async getReqDetails (reqId) {
      const res = await api.GET_USER_CERTIFICATE_REQ_DETAIL(reqId)
      this.visReqDetails = res
      this.modelForCertificate = true
    },
    /**
     * 打开修改个人信息的表单
     */
    openFormForUpdate () {
      this.modelForUpdate = true
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
      this.$store.state.d2admin.user.info.headImg = await api.DOWNLOAD_FILE(res.id)
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
    },
  },
  mounted () {
    this.getUserInfo()
    this.getReqList()
  }
}
</script>

<style scoped>

</style>
