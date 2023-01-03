<template>
  <d2-container>
    <template v-slot:header>
      <el-row >
        <el-col>
          <el-select v-model="curShopId" placeholder="请选择">
            <el-option
              v-for="item in shopList"
              :key="item.id"
              :label="item.name"
              :value="item.id">
            </el-option>
          </el-select>
        </el-col>
        <el-col style="text-align: center">
          <el-avatar style="margin-left: 10px;" :size="150" :src="shopImg"></el-avatar>
        </el-col>
      </el-row>
      <el-row>
        <el-col style="text-align: center">
          <h2 style="text-align:center">{{curShopDetails.name}}</h2>
        </el-col>
        <el-col style="text-align: right; margin-top: -30px">
          <el-upload
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

    <!--基本信息-->
    <el-collapse :value="['1', '2', '3']">
      <el-collapse-item title="基本信息" name="1">
        <el-descriptions class="margin-top"  :column="2"  border>
          <!--店铺名-->
          <el-descriptions-item>
            <template slot="label">
              <i class="el-icon-user"></i>
              店铺名
            </template>
            {{curShopDetails.name}}
          </el-descriptions-item>
          <!--店主-->
          <el-descriptions-item>
            <template slot="label">
              <i class="el-icon-user"></i>
              店铺类型
            </template>
            {{curShopDetails.type === 0 ? '个人店铺' : '合作店铺'}}
          </el-descriptions-item>
          <!--注册时间-->
          <el-descriptions-item>
            <template slot="label">
              <i class="el-icon-user"></i>
              注册时间
            </template>
            {{curShopDetails.reg_time.slice(0, curShopDetails.reg_time.indexOf('T'))}}
          </el-descriptions-item>
          <!--店铺评分 -->
          <el-descriptions-item>
            <template slot="label">
              <i class="el-icon-user"></i>
              店铺评分
            </template>
            <el-rate v-if="curShopDetails.grade"
              v-model="curShopDetails.grade"
              disabled
              show-score
              text-color="#ff9900"
              score-template="{value}">
            </el-rate>
            <div v-else>暂无评分</div>
          </el-descriptions-item>
          <!--店铺介绍-->
          <el-descriptions-item>
            <template slot="label">
              <i class="el-icon-user"></i>
              店铺介绍
            </template>
            {{curShopDetails.introduction === '' ? '无' : curShopDetails.introduction}}
          </el-descriptions-item>
        </el-descriptions>
      </el-collapse-item>

      <!--店主信息-->
      <el-collapse-item title="店主信息" name="2">
        <el-descriptions class="margin-top"  :column="2"  border>
          <!--店主id-->
          <el-descriptions-item>
            <template slot="label">
              <i class="el-icon-user"></i>
              店主id
            </template>
            {{curShopDetails.owner.id}}
          </el-descriptions-item>
          <!--店主昵称-->
          <el-descriptions-item>
            <template slot="label">
              <i class="el-icon-user"></i>
              店主昵称
            </template>
            {{curShopDetails.owner.nickname}}
          </el-descriptions-item>
          <!--店主学号-->
          <el-descriptions-item>
            <template slot="label">
              <i class="el-icon-user"></i>
              店主学号
            </template>
            {{curShopDetails.owner.student_id}}
          </el-descriptions-item>
          <!--店主姓名-->
          <el-descriptions-item>
            <template slot="label">
              <i class="el-icon-user"></i>
              店主姓名
            </template>
            {{curShopDetails.owner.real_name}}
          </el-descriptions-item>
        </el-descriptions>
      </el-collapse-item>

      <!--管理员信息-->
      <el-collapse-item v-if="curShopDetails.type === 1" title="管理员信息" name="3">
        <el-table
          border
          highlight-current-row
          :data="curShopDetails.admins"
          style="width: 100%">
          <el-table-column
            prop="student_id"
            align="center"
            label="管理员学号">
          </el-table-column>
          <el-table-column
            prop="real_name"
            align="center"
            label="管理员姓名">
          </el-table-column>
          <el-table-column
            prop="nickname"
            align="center"
            label="管理员昵称">
          </el-table-column>
        </el-table>
        <br>
        <div style="text-align: center">
          <el-button type="success" @click="addAdmin">增加管理员</el-button>
          <el-button type="danger" @click="deleteAdmin">删除管理员</el-button>
        </div>
      </el-collapse-item>
    </el-collapse>
  </d2-container>
</template>

<script>
import api from '@/api'
import util from '@/libs/util'

export default {
  name: 'shop-details',
  data () {
    return {
      token: util.cookies.get('token'),
      userId: this.$store.state.d2admin.user.info.id,
      shopList: [],
      ownerShopList: [],
      adminShopList: [],
      curShopId: 0,
      curShopDetails: {}
    }
  },
  computed: {
    shopImg () {
      if (this.curShopDetails.img_url == null) {
        return 'https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png'
      } else {
        return this.curShopDetails.img_url
      }
    }
  },
  methods: {
    async getShopList () {
      const res = await api.GET_USER_SHOP_LIST(this.userId)
      this.ownerShopList = res.owner_shop
      this.adminShopList = res.admin_shop
      this.shopList = this.ownerShopList.concat(this.adminShopList)
      console.log(this.ownerShopList)
      console.log(this.adminShopList)
      console.log(this.shopList)
    },
    async getShopDetails () {
      const res = await api.GET_SHOP_DETAILS(this.curShopId)
      this.curShopDetails = res
      console.log(res)
    },
    addAdmin () {
      this.$prompt('请输入要添加的管理员学号', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消'
      }).then((res) => {
        api.ADD_SHOP_ADMIN(this.curShopId, res.value)
          .then(() => {
            this.$Message.success('添加成功！')
            this.getShopDetails()
          })
          .catch(() => {
            this.$Message.error('添加失败！')
          })
      })
    },
    deleteAdmin () {
      this.$prompt('请输入要删除的管理员学号', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消'
      }).then((res) => {
        api.DELETE_SHOP_ADMIN(this.curShopId, res.value)
          .then(() => {
            this.$Message.success('删除成功！')
            this.getShopDetails()
          })
          .catch(() => {
            this.$Message.error('删除失败！')
          })
      })
    },
    /**
     * 上传新头像
     */
    async handleUploadSuccess (res, file) {
      await api.SET_SHOP_IMG(res.id, this.curShopId)
      this.$Message.success('上传成功！')
      await this.getShopDetails()
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
  watch: {
    curShopId: {
      handler (newVal) {
        this.getShopDetails()
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
          this.getShopDetails()
        }
      })
  }
}
</script>

<style scoped>

</style>
