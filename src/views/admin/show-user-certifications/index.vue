<template>
  <d2-container>
    <template v-slot:header>
      <h3>学生认证列表</h3>
    </template>
    <el-table
      :data="tableData"
      style="width: 100%"
      border
      highlight-current-row
      @sort-change="handleSortChange"
    >
      <el-table-column
        prop="student_id"
        sortable="custom"
        label="学号"
        align="center"
        width="180">
        <template v-slot="scope">
          <div v-if="scope.$index === 0">
            <el-input
              v-model="queryStudentId"
              size="small"
              placeholder="查询学号"
              @change="queryReqsByStudentId"
            />
          </div>
          <div v-else>{{ (scope.row.student_id) }}</div>
        </template>
      </el-table-column>
      <el-table-column
        prop="student_name"
        label="学生姓名"
        align="center"
        width="180">
        <template v-slot="scope">
          <div v-if="scope.$index === 0">
            <el-input
              v-model="queryStudentName"
              size="small"
              placeholder="查询学生姓名"
              @change="queryReqsByStudentName"
            />
          </div>
          <div v-else>{{ (scope.row.student_name) }}</div>
        </template>
      </el-table-column>
      <el-table-column
        prop="user_id"
        label="用户ID"
        align="center"
        width="100">
        <template v-slot="scope">
          <div v-if="scope.$index === 0">
            <el-input
              v-model="queryUserId"
              size="small"
              placeholder="查询用户"
              @change="queryReqsByUserId"
            />
          </div>
          <div v-else>{{ (scope.row.user_id) }}</div>
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
              placeholder="查询用户名"
              @change="queryReqsByUsername"
            />
          </div>
          <div v-else>{{ (scope.row.username) }}</div>
        </template>
      </el-table-column>
      <el-table-column
        prop="depart"
        label="院系"
        align="center"
        width="180">
        <template v-slot="scope">
          <div v-if="scope.$index === 0">
            <el-select v-model="queryDepart" clearable placeholder="查询院系" size="mini" style="width: 100%" @change="queryReqsByDepart">
              <el-option
                v-for="item in departList"
                :key="item.value"
                :label="item.label"
                :value="item.value">
              </el-option>
            </el-select>
          </div>
          <div v-else>{{ getDepartNameById(scope.row.depart) }}</div>
        </template>
      </el-table-column>
      <el-table-column
        prop="req_time"
        label="认证时间"
        align="center"
        width="200">
        <template v-slot="scope">
          <div v-if="scope.$index === 0">
            <el-date-picker
              size="small"
              style="width: 100%"
              v-model="queryReqTime"
              type="date"
              value-format="yyyy-MM-dd"
              @change="queryReqsByReqTime"
              placeholder="选择日期">
            </el-date-picker>
          </div>
          <div v-else>{{ formatTime(scope.row.req_time) }}</div>
        </template>
      </el-table-column>
      <el-table-column
        prop="status"
        label="审批状态"
        align="center"
        width="200">
        <template v-slot="scope">
          <div v-if="scope.$index === 0">
            <!--<el-select v-model="queryStatus" size="small" clearable placeholder="请选择" @change="queryReqsByStatus">-->
            <!--  <el-option label="等待审批" value="0"></el-option>-->
            <!--  <el-option label="审批通过" value="1"></el-option>-->
            <!--  <el-option label="拒绝审批" value="2"></el-option>-->
            <!--</el-select>-->
          </div>
          <div v-else>
              <!--<el-button v-if="scope.row.status === 0" type="primary" size="mini" @click="showReqDetails(scope.row.id)">等待审批</el-button>-->
              <!--<el-button v-else-if="scope.row.status === 1" type="success" size="mini" @click="showReqDetails(scope.row.id)">审批通过</el-button>-->
              <!--<el-button v-else type="danger" size="mini" @click="showReqDetails(scope.row.id)">拒绝审批</el-button>-->
            <el-button type="primary" size="mini" @click="showReqDetails(scope.row.student_id)">查看详情</el-button>
          </div>
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
    <!--抽屉-->
    <el-drawer
      title="申请详情"
      :visible.sync="drawer"
      direction="rtl">
      <h3 style="margin-left: 20px">学生基本信息</h3><br>
      <el-descriptions class="margin-top"  :column="1"  border>
        <el-descriptions-item>
          <template slot="label">
            <i class="el-icon-user"></i>
            学号
          </template>
          {{reqDetails.student_id}}
        </el-descriptions-item>
        <el-descriptions-item>
          <template slot="label">
            <i class="el-icon-user"></i>
            学生姓名
          </template>
          {{reqDetails.student_name}}
        </el-descriptions-item>
        <el-descriptions-item>
          <template slot="label">
            <i class="el-icon-user"></i>
            性别
          </template>
          {{reqDetails.gender === 0 ? "男" : "女"}}
        </el-descriptions-item>
        <el-descriptions-item>
          <template slot="label">
            <i class="el-icon-user"></i>
            学院
          </template>
          {{ getDepartNameById(reqDetails.depart) }}
        </el-descriptions-item>
        <el-descriptions-item>
          <template slot="label">
            <i class="el-icon-user"></i>
            入学年份
          </template>
          {{reqDetails.attendance_year}}
        </el-descriptions-item>
      </el-descriptions>
      <br><h3 style="margin-left: 20px">学生证件图片</h3><br>
      <img :src="reqDetails.image_url" style="width: 100%">
      <br><br>
      <!--如果处于待审批的状态，则显示下面的内容-->
      <template v-if="reqDetails.status === 0">
        <el-form ref="form" :model="form" label-width="80px">
          <el-form-item label="是否通过">
            <el-radio v-model="pass" :label="true">通过</el-radio>
            <el-radio v-model="pass" :label="false">拒绝</el-radio>
          </el-form-item>
          <el-form-item label="审批意见">
            <el-input v-model.trim="comment" @keydown.enter="dealReq"></el-input>
          </el-form-item>
        </el-form>
        <el-button style="margin-left: 45%" type="primary" @click="dealReq">
          提交
        </el-button>
      </template>
    </el-drawer>
  </d2-container>
</template>

<script>
import api from '@/api'
import { getDepartNameById, departList } from "@/libs/util.depart";
import util from '@/libs/util'

export default {
  name: 'show-user-certifications',
  data () {
    return {
      // 请求详细信息
      reqDetails: {},
      reqId: '',
      pass: true,
      comment: '',
      drawer: false,
      // 用户输入的查询参数
      queryUserId: '',
      queryUsername: '',
      queryStudentName: '',
      queryStudentId: '',
      queryReqTime: '',
      queryStatus: '',
      queryDepart: '',
      // 当前页面
      currentPage: 1,
      // 筛选之后的记录总数
      filterTotalCnt: 0,
      // 筛选器和排序规则，用于构造请求的params
      filter: {},
      order_by: {
        student_id_asc: true
      },
      // 服务器返回的数据
      tableData: [{}],
      // 院系列表
      departList: departList
    }
  },
  methods: {
    getDepartNameById,
    formatTime: util.time.formatTime,
    /**
     * 查看审批状态详情
     */
    showReqDetails (studentId) {
      // alert(reqId)
      this.drawer = true
      api.GET_USER_CERTIFICATE_DETAILS(studentId)
        .then((res) => {
          this.reqDetails = res
        })
        .catch((err) => {
          console.log(err)
        })
    },
    /**
     * 根据curPage,filter,sort_by构造params，并发送请求
     */
    queryReqs () {
      const params = {
        ...this.filter,
        ...this.order_by,
        page: this.currentPage
      }
      console.log(params)
      api.GET_USER_CERTIFICATE_LIST_ADMIN(params)
        .then((data) => {
          console.log(data)
          this.tableData = data.data
          this.tableData.unshift({})
          this.filterTotalCnt = data.tot_count
        })
        .catch((err) => {
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
      this.queryReqs()
    },
    /**
     * 响应用户对排序规则的修改
     * 并重新发送请求
     * @param value
     */
    handleSortChange (value) {
      if (value.prop === 'student_id') {
        if (value.order === 'ascending') {
          this.order_by = { student_id_asc: true }
        } else if (value.order === 'descending') {
          this.order_by = { student_id_desc: true }
        } else {
          this.order_by = { student_id_asc: true }
        }
      }
      else if (value.prop === 'user_id') {
        if (value.order === 'ascending') {
          this.order_by = { user_id_asc: true }
        } else if (value.order === 'descending') {
          this.order_by = { user_id_desc: true }
        } else {
          this.order_by = { student_id_asc: true }
        }
      }
      this.currentPage = 1
      this.queryReqs()
    },
    /**
     * 根据用户输入的id进行查询(完全匹配)
     */
    queryReqsById () {
      if (this.queryId !== '') {
        Object.assign(this.filter, { id__exact: this.queryId })
      } else {
        delete this.filter.id__exact
      }
      this.currentPage = 1
      this.queryReqs()
    },
    /**
     * 根据用户输入的用户名进行查询(部分匹配)
     */
    queryReqsByUserId () {
      if (this.queryUserId !== '') {
        Object.assign(this.filter, { user_id_exact: this.queryUserId })
      } else {
        delete this.filter.user_id_exact
      }
      this.currentPage = 1
      this.queryReqs()
    },
    /**
     * 根据用户输入的昵称进行查询(部分匹配)
     */
    queryReqsByUsername () {
      if (this.queryUsername !== '') {
        Object.assign(this.filter, { username_fuzzy: this.queryUsername })
      } else {
        delete this.filter.username_fuzzy
      }
      this.currentPage = 1
      this.queryReqs()
    },
    /**
     * 根据用户输入的学号进行查询(部分匹配)
     */
    queryReqsByStudentId () {
      if (this.queryStudentId !== '') {
        Object.assign(this.filter, { student_id_fuzzy: this.queryStudentId })
      } else {
        delete this.filter.student_id_fuzzy
      }
      this.currentPage = 1
      this.queryReqs()
    },
    /**
     * 根据用户输入的学生姓名进行查询(部分匹配)
     */
    queryReqsByStudentName () {
      if (this.queryStudentName !== '') {
        Object.assign(this.filter, { student_name_fuzzy: this.queryStudentName })
      } else {
        delete this.filter.student_name_fuzzy
      }
      this.currentPage = 1
      this.queryReqs()
    },
    /**
     * 根据用户输入的学生院系进行查询(部分匹配)
     */
    queryReqsByDepart () {
      if (this.queryDepart !== '') {
        Object.assign(this.filter, { depart_exact: this.queryDepart })
      } else {
        delete this.filter.depart_exact
      }
      this.currentPage = 1
      this.queryReqs()
    },
    /**
     * 根据用户选择的认证时间进行查询(部分匹配)
     */
    queryReqsByReqTime () {
      console.log(this.queryReqTime)
      if (this.queryReqTime !== null && this.queryReqTime !== '') {
        Object.assign(this.filter, { reg_date: this.queryReqTime })
      } else {
        delete this.filter.reg_date
      }
      this.currentPage = 1
      this.queryReqs()
    }
  },
  mounted () {
    this.currentPage = 1
    this.queryReqs()
  }
}
</script>

<style scoped>

</style>
