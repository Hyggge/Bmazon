<template>
  <d2-container ref="container">
    <template v-slot:header>
      <!--搜索框-->
      <div style="text-align: center">
        <el-input
          type="text"
          prefix-icon="el-icon-search"
          v-model="query.keyword"
          placeholder="搜索文章"
          style="width: 500px; cursor: pointer"
          @keyup.enter.native="queryArticlesByKeyword"
        ></el-input>
        <el-button type="warning" style="margin-left: 10px" @click="queryArticlesByKeyword">搜索</el-button>
      </div>
    </template>
    <el-form :inline="true" :model="filter"
             class="demo-form-inline"
             style="text-align: center">

      <!--时间选择器-->
      <el-form-item label="时间选择">
        <el-date-picker
          v-model="query.dayRange"
          type="daterange"
          size="small"
          value-format="yyyy-MM-dd"
          @change="queryArticlesByDateRange"
          range-separator="至"
          start-placeholder="开始日期"
          end-placeholder="结束日期">
        </el-date-picker>
      </el-form-item>
      <!--排序规则-->
      <el-form-item label="排序规则" size="small" style="margin-left: 20px">
        <el-select v-model="orderBy" placeholder="请选择" @change="queryArticles">
          <el-option label="时间升序" :value="0"></el-option>
          <el-option label="时间降序" :value="1"></el-option>
        </el-select>
      </el-form-item>
    </el-form>

    <!--文章列表-->
    <el-row :gutter="30">
      <el-col v-for="article in articleList" :key="article.id" :span="6" style="margin-bottom: 20px">
        <div @click="showDetails(article.id)">
          <el-card style="height: 250px; cursor: pointer">
            <div slot="header" class="clearfix">
              <h3>
                <span>{{article.title}}</span>
              </h3>
              <div class="author">作者: {{article.user__nickname}}</div>
              <div class="time">  时间: {{formatTime(article.post_time)}}</div>
              <div class="time" style="margin-top: 2px">
                <img src="../../../assets/img/liked.svg" alt="" style="width: 14px; ">
                <span style="padding-top: 10px">{{article.star_count}}</span>
                <img src="../../../assets/img/collected.svg" alt="" style="width: 14px; margin-left: 7px">
                <span>{{article.collect_count}}</span>
              </div>
            </div>
            <p>
              {{ modifyContent(article.content) }}
            </p>
          </el-card>
        </div>
      </el-col>
    </el-row>

    <!--分页栏-->
    <div class="block" style="margin-top: 10px">
      <el-pagination
        hi
        background
        layout="prev, pager, next,jumper, ->, total, slot"
        :total="filterTotalCnt"
        @current-change="handleCurrentChange"
        :current-page="currentPage"
        :page-size="12"
        style="text-align: center">
      </el-pagination>
    </div>

  </d2-container>
</template>

<script>
import api from '@/api'
import util from '@/libs/util'

export default {
  name: 'show-all-articles',
  data () {
    return {
      // 商品列表
      articleList: [],
      // 用户输入的查询条件
      query: {
        keyword: '',
        dayRange: []
      },
      // 筛选器
      filter: {},
      // 排序规则
      orderBy: 1, // 表示时间升序,1表示时间降序
      // 当前页面
      currentPage: 1,
      // 筛选之后的记录总数
      filterTotalCnt: 0
    }
  },
  methods: {
    formatTime: util.time.formatTime,
    /**
     * 获得文章列表
     */
    async queryArticles () {
      const params = {
        ...this.filter,
        page: this.currentPage
      }
      // 增加排序规则
      if (this.orderBy === 0) {
        params.order_by = 'post_time'
      } else {
        params.order_by = '-post_time'
      }
      // 发送请求
      const res = await api.GET_ARTICLE_LIST_FOR_USER(params)
      this.filterTotalCnt = res.tot_count
      this.articleList = res.data
      console.log(res)
    },
    /**
     * 根据用户的输入的关键词进行查询
     */
    queryArticlesByKeyword () {
      if (this.query.keyword !== '') {
        Object.assign(this.filter, { title__contains: this.query.keyword })
      } else {
        delete this.filter.title__contains
      }
      this.currentPage = 1
      this.queryArticles()
    },
    /**
     * 根据用户选择的时间范围进行查询
     */
    queryArticlesByDateRange () {
      console.log(this.query.dayRange)
      if (this.query.dayRange !== [] && this.query.dayRange !== null) {
        const startDate = this.query.dayRange[0].split('-')
        const endDate = this.query.dayRange[1].split('-')
        Object.assign(this.filter, {
          post_time__year__gte: startDate[0],
          post_time__year__lte: endDate[0],
          post_time__month__gte: startDate[1],
          post_time__month__lte: endDate[1],
          post_time__day__gte: startDate[2],
          post_time__day__lte: endDate[2]
        })
      } else {
        delete this.filter.post_time__year__gte
        delete this.filter.post_time__year__lte
        delete this.filter.post_time__month__gte
        delete this.filter.post_time__month__lte
        delete this.filter.post_time__day__gte
        delete this.filter.post_time__day__lte
      }
      this.currentPage = 1
      this.queryArticles()
    },
    /**
     * 简化文章内容
     */
    modifyContent (content) {
      const ans = String(content)
      if (ans.length > 50) {
        return ans.slice(0, 30) + '...'
      } else {
        return ans + '...'
      }
    },
    /**
     * 前往展示文章细节的页面
     */
    showDetails (articleId) {
      this.$router.push({ path: `/article/show-details/${articleId}` })
    },
    /**
     * 响应用户对展示页面下标的修改
     * 并重新发送请求
     */
    async handleCurrentChange (value) {
      this.currentPage = value
      await this.queryArticles()
      this.$refs.container.scrollToTop()
    }
  },
  mounted () {
    this.queryArticles()
  }
}
</script>

<style scoped>
.author, .time{
  font-size: 12px;
  color: lightslategray;
}
</style>
