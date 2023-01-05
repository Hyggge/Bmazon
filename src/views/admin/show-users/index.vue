<template>
  <d2-container>
    <template v-slot:header>
      <el-row :gutter="20">
        <el-col :span="6"><h3>用户列表</h3></el-col>
        <el-col :span="3" :offset="15" style="margin-top: -10px; text-align: right">
            <el-button size="mini" type="primary" @click="exportToCsv">导出为csv</el-button>
        </el-col>
      </el-row>

      <!--<el-row>-->
      <!--  <el-col :span="3" :offset="21" style="text-align: right">-->
      <!--    <el-tooltip class="item" effect="dark" content="上传文件应为csv格式，表头属性依次为username，password，phone_no，email" placement="left">-->
      <!--      <el-upload-->
      <!--        class="upload-demo"-->
      <!--        :headers="{Authorization: 'Bearer ' + token}"-->
      <!--        :on-success="handleUploadSuccess"-->
      <!--        :on-error="handleUploadError"-->
      <!--        :show-file-list="false"-->
      <!--        action="/api/auth/batch/register">-->
      <!--        <el-button size="mini"  type="success">批量创建用户</el-button>-->
      <!--      </el-upload>-->
      <!--    </el-tooltip>-->
      <!--  </el-col>-->
      <!--</el-row>-->

    </template>
    <el-table
      :data="tableData"
      style="width: 100%"
      border
      highlight-current-row
      @sort-change="handleSortChange"
    >
      <el-table-column
        prop="id"
        label="ID"
        align="center"
        sortable="custom"
        width="100">
        <template v-slot="scope">
          <div v-if="scope.$index === 0">
            <el-input
              v-model="queryId"
              size="small"
              placeholder="查询id"
              @change="queryUsersById"
            />
          </div>
          <div v-else>{{ (scope.row.id) }}</div>
        </template>
      </el-table-column>
      <el-table-column
        prop="username"
        label="用户名"
        align="center"
        width="180">
        <template v-slot="scope">
          <div v-if="scope.$index === 0">
            <el-input
              v-model="queryUsername"
              size="small"
              placeholder="查询用户"
              @change="queryUsersByUsername"
            />
          </div>
          <div v-else>{{ (scope.row.username) }}</div>
        </template>
      </el-table-column>
      <el-table-column
        prop="email"
        label="邮箱"
        align="center"
        width="180">
        <template v-slot="scope">
          <div v-if="scope.$index === 0">
            <el-input
              v-model="queryEmail"
              size="small"
              placeholder="查询邮箱"
              @change="queryUsersByEmail"
            />
          </div>
          <div v-else>{{ (scope.row.email) }}</div>
        </template>
      </el-table-column>
      <el-table-column
        prop="phone_no"
        label="手机号"
        align="center"
        width="180">
        <template v-slot="scope">
          <div v-if="scope.$index === 0">
            <el-input
              v-model="queryPhoneNo"
              size="small"
              placeholder="查询手机号"
              @change="queryUsersByPhoneNo"
            />
          </div>
          <div v-else>{{ (scope.row.phone_no) }}</div>
        </template>
      </el-table-column>
      <el-table-column
        prop="reg_time"
        label="注册时间"
        align="center"
        width="200">
        <template v-slot="scope">
          <div v-if="scope.$index === 0">
            <el-date-picker
              v-model="queryRegTime"
              type="date"
              value-format="yyyy-MM-dd"
              @change="queryUsersByRegTime"
              placeholder="选择日期">
            </el-date-picker>
          </div>
          <div v-else>{{ formatTime(scope.row.reg_time)  }}</div>
        </template>
      </el-table-column>
    </el-table>
    <!--分页栏-->
    <div class="block" style="margin-top: 10px">
      <el-pagination
        hi
        background
        layout="prev, pager, next,jumper, ->, total, slot"
        :total="filterTotalCnt"
        @current-change="handleCurrentChange"
        :current-page="currentPage"
        :page-size="10"
        style="text-align: center">
      </el-pagination>
    </div>
  </d2-container>
</template>

<script>
import api from '@/api'
import util from '@/libs/util'

export default {
  name: 'show-users',
  data () {
    return {
      token: util.cookies.get('token'),
      // 用户输入的查询参数
      queryId: '',
      queryUsername: '',
      queryPhoneNo: '',
      queryEmail: '',
      queryRegTime: '',
      // 当前页面
      currentPage: 1,
      // 筛选之后的记录总数
      filterTotalCnt: 0,
      // 筛选器和排序规则，用于构造请求的params
      filter: {},
      order_by: {
        id_asc: true
      },
      // 服务器返回的数据
      tableData: [{}]
    }
  },
  methods: {
    formatTime: util.time.formatTime,
    /**
     * 导出用户csv文件
     */
    async exportToCsv () {
      const res = await api.GET_USER_CSV()
      let data = res.split('\n')
      data = data.join('\n')
      var blob = new Blob(['\uFEFF' + data], { type: 'text/csv,charset=UTF-8' })
      const a = document.createElement('a')
      a.href = URL.createObjectURL(blob)
      a.download = '用戶列表.csv'
      a.click()
    },
    /**
     * 根据curPage,filter,sort_by构造params，并发送请求
     */
    queryUsers () {
      const params = {
        ...this.filter,
        ...this.order_by,
        page: this.currentPage
      }
      api.GET_USER_LIST_FOR_ADMIN(params)
        .then((data) => {
          console.log(data)
          this.tableData = data.data
          this.tableData.unshift({})
          this.filterTotalCnt = data.tot_count
        }).catch((err) => {
          console.log(err.response.data)
        })
    },
    /**
     * 响应用户对展示页面下标的修改
     * 并重新发送请求
     * @param value
     */
    handleCurrentChange (value) {
      this.currentPage = value
      this.queryUsers()
    },
    /**
     * 响应用户对排序规则的修改
     * 并重新发送请求
     * @param value
     */
    handleSortChange (value) {
      if (value.prop === 'id') {
        if (value.order === 'ascending') {
          this.order_by = { id_asc: true }
        } else if (value.order === 'descending') {
          this.order_by = { id_desc: true }
        } else {
          this.order_by = { id_asc: true }
        }
      }
      this.currentPage = 1
      this.queryUsers()
    },
    /**
     * 根据用户输入的id进行查询(完全匹配)
     */
    queryUsersById () {
      if (this.queryId !== '') {
        Object.assign(this.filter, { id_exact: this.queryId })
      } else {
        delete this.filter.id_exact
      }
      this.currentPage = 1
      this.queryUsers()
    },
    /**
     * 根据用户输入的用户名进行查询(部分匹配)
     */
    queryUsersByUsername () {
      if (this.queryUsername !== '') {
        Object.assign(this.filter, { username_fuzzy: this.queryUsername })
      } else {
        delete this.filter.username_fuzzy
      }
      this.currentPage = 1
      this.queryUsers()
    },
    /**
     * 根据用户输入的手机号进行查询(部分匹配)
     */
    queryUsersByPhoneNo () {
      if (this.queryPhoneNo !== '') {
        Object.assign(this.filter, { phone_no_fuzzy: this.queryPhoneNo })
      } else {
        delete this.filter.phone_no_fuzzy
      }
      this.currentPage = 1
      this.queryUsers()
    },
    /**
     * 根据用户输入的邮箱进行查询(部分匹配)
     */
    queryUsersByEmail () {
      if (this.queryEmail !== '') {
        Object.assign(this.filter, { email_fuzzy: this.queryEmail })
      } else {
        delete this.filter.email_fuzzy
      }
      this.currentPage = 1
      this.queryUsers()
    },
    /**
     * 根据用户选择的注册时间进行查询(部分匹配)
     */
    queryUsersByRegTime () {
      console.log(this.queryRegTime)
      if (this.queryRegTime !== null && this.queryRegTime !== '') {
        Object.assign(this.filter, { reg_date: this.queryRegTime })
      } else {
        delete this.filter.reg_date
      }
      this.currentPage = 1
      this.queryUsers()
    },
    /**
     * 批量创建用户
     */
    handleUploadSuccess (res, file) {
      // console.log(res)
      if (res.error_msg != null) {
        this.$Message.error({
          content: res.error_msg.join('  \n\n'),
          duration: 10,
          closable: true
        })
      } else {
        this.$Message.success('创建成功！')
      }
    },
    handleUploadError (res, file) {
      // console.log(res)
      this.$Message.error('文件不合法')
    }
  },
  mounted () {
    // 如果当前用户不是管理员，则发出提示信息
    if (this.$store.state.d2admin.user.info.role === 0) {
      this.queryUsers()
    } else {
      this.$Message.error('您不是管理员，无权查看该页面的内容！')
    }
  }
}
</script>

<style scoped>

</style>
