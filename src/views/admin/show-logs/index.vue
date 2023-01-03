<template>
  <d2-container>
    <template v-slot:header>
      <el-row>
        <el-col><h3>日志列表</h3></el-col>
        <el-col style="text-align: right; margin-top: -30px">
          <el-button type="primary" @click="exportToCsv">导出为csv</el-button>
        </el-col>
      </el-row>

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
        prop="user_id"
        label="用户ID"
        align="center"
        width="180">
        <template v-slot="scope">
          <div v-if="scope.$index === 0">
            <el-input
              v-model="queryUserId"
              size="small"
              placeholder="查询用户ID"
              @change="queryUsersByUserId"
            />
          </div>
          <div v-else>{{ (scope.row.user_id) }}</div>
        </template>
      </el-table-column>
      <el-table-column
        prop="user_nickname"
        label="昵称"
        align="center"
        width="180">
        <template v-slot="scope">
          <div v-if="scope.$index === 0">
            <el-input
              v-model="queryNickname"
              size="small"
              placeholder="查询昵称"
              @change="queryUsersByNickname"
            />
          </div>
          <div v-else>{{ (scope.row.user__nickname) }}</div>
        </template>
      </el-table-column>
      <el-table-column
        prop="detail"
        label="操作详情"
        align="center"
        width="180">
        <template v-slot="scope">
          <div v-if="scope.$index === 0">
            <el-input
              v-model="queryDetails"
              size="small"
              placeholder="查询操作详情"
              @change="queryUsersByDetails"
            />
          </div>
          <div v-else>{{ (scope.row.detail) }}</div>
        </template>
      </el-table-column>
      <el-table-column
        prop="op_time"
        label="操作时间"
        align="center"
        width="200">
        <template v-slot="scope">
          <div v-if="scope.$index === 0">
            <el-date-picker
              v-model="queryOpTime"
              type="date"
              value-format="yyyy-MM-dd"
              @change="queryUsersByOpTime"
              placeholder="选择日期">
            </el-date-picker>
          </div>
          <div v-else>{{ formatTime(scope.row.op_time)  }}</div>
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
  name: 'show-logs',
  data () {
    return {
      // 用户输入的查询参数
      queryId: '',
      queryUserId: '',
      queryUsername: '',
      queryNickname: '',
      queryDetails: '',
      queryOpTime: '',
      // 当前页面
      currentPage: 1,
      // 筛选之后的记录总数
      filterTotalCnt: 0,
      // 筛选器和排序规则，用于构造请求的params
      filter: {},
      order_by: {
        order_by: 'id'
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
      const res = await api.GET_LOG_CSV()
      let data = res.split('\n')
      data = data.join('\n')
      var blob = new Blob(['\uFEFF' + data], { type: 'text/csv,charset=UTF-8' })
      const a = document.createElement('a')
      a.href = URL.createObjectURL(blob)
      a.download = '日志列表.csv'
      a.click()
    },
    /**
     * 根据curPage,filter,sort_by构造params，并发送请求
     */
    async queryLogs () {
      const params = {
        ...this.filter,
        ...this.order_by,
        page: this.currentPage
      }
      const res = await api.GET_LOG_LIST(params)
      console.log(res)
      this.tableData = res.data
      this.tableData.unshift({})
      this.filterTotalCnt = res.filter_count
    },
    /**
     * 响应用户对展示页面下标的修改
     * 并重新发送请求
     */
    handleCurrentChange (value) {
      this.currentPage = value
      this.queryLogs()
    },
    /**
     * 响应用户对排序规则的修改
     * 并重新发送请求
     * @param value
     */
    handleSortChange (value) {
      if (value.prop === 'id') {
        if (value.order === 'ascending') {
          Object.assign(this.order_by, { order_by: 'id' })
        } else if (value.order === 'descending') {
          Object.assign(this.order_by, { order_by: '-id' })
        } else {
          Object.assign(this.order_by, { order_by: 'id' })
        }
      }
      this.currentPage = 1
      this.queryLogs()
    },
    /**
     * 根据用户输入的id进行查询(完全匹配)
     */
    queryUsersById () {
      if (this.queryId !== '') {
        Object.assign(this.filter, { id__exact: this.queryId })
      } else {
        delete this.filter.id__exact
      }
      this.currentPage = 1
      this.queryLogs()
    },
    /**
     * 根据用户输入的用户名进行查询(部分匹配)
     */
    queryUsersByUserId () {
      if (this.queryUserId !== '') {
        Object.assign(this.filter, { user_id__exact: this.queryUserId })
      } else {
        delete this.filter.user_id__exact
      }
      this.currentPage = 1
      this.queryLogs()
    },
    /**
     * 根据用户输入的昵称进行查询(部分匹配)
     */
    queryUsersByNickname () {
      if (this.queryNickname !== '') {
        Object.assign(this.filter, { user__nickname__contains: this.queryNickname })
      } else {
        delete this.filter.user__nickname__contains
      }
      this.currentPage = 1
      this.queryLogs()
    },
    /**
     * 根据用户输入的邮箱进行查询(部分匹配)
     */
    queryUsersByDetails () {
      if (this.queryDetails !== '') {
        Object.assign(this.filter, { detail__contains: this.queryDetails })
      } else {
        delete this.filter.detail__contains
      }
      this.currentPage = 1
      this.queryLogs()
    },
    /**
     * 根据用户选择的注册时间进行查询(部分匹配)
     */
    queryUsersByOpTime () {
      console.log(this.queryOpTime)
      if (this.queryOpTime !== null && this.queryOpTime !== '') {
        const date = this.queryOpTime.split('-')
        Object.assign(this.filter, { op_time__year: date[0], op_time__month: date[1], op_time__day: date[2] })
      } else {
        delete this.filter.op_time__year
        delete this.filter.op_time__month
        delete this.filter.op_time__day
      }
      this.currentPage = 1
      this.queryLogs()
    }
  },
  mounted () {
    this.currentPage = 1
    this.queryLogs()
  }
}
</script>

<style scoped>

</style>
