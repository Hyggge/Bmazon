<template>
  <d2-container>
    <template v-slot:header>
      <div class="title">{{articleDetails.title}}</div>
      <div class="info">
        <span class="author">作者: {{articleDetails.user__nickname}}</span>
        <span class="time">发布时间: {{formatTime(articleDetails.post_time)}}</span>
      </div>
      <div class="btn">
        <el-button v-if="articleDetails.star" circle size="mini"  @click="cancelStar">
          <img src="../../../assets/img/liked.svg" alt= "" style="width: 10px">
        </el-button>
        <el-button v-else  circle size="mini" @click="clickStar">
          <img src="../../../assets/img/not-liked.svg" alt= "" style="width: 10px">
        </el-button>

        <el-button class="link" size="mini" type="danger" @click="showCommodityDetails"> 商品传送门 </el-button>
        <el-button class="link" size="mini" type="primary" @click="copyLink"> 复制文章连接 </el-button>
        <el-button v-if="auth.id === articleDetails.user_id" class="link" size="mini" type="warning" @click="modifyArticle"> 修改文章 </el-button>

        <el-button v-if="articleDetails.collect" circle size="mini" @click="cancelCollect">
          <img src="../../../assets/img/collected.svg" alt= "" style="width: 10px">
        </el-button>
        <el-button v-else circle size="mini" @click="clickCollect">
          <img src="../../../assets/img/not-collected.svg" alt= "" style="width: 10px">
        </el-button>
      </div>
    </template>

    <!--文章内容-->
    <div v-html="render(this.articleDetails.content.replace(/\n/g, `<br>`))" class="markdown-body"></div>

    <!--用户回复-->
    <el-tabs v-model="curPane" class="reply">
      <el-tab-pane label="用户回复" name="reply">
        <reply :articleId="articleId"></reply>
      </el-tab-pane>
    </el-tabs>
  </d2-container>

</template>

<script>
import api from '@/api'
import util from '@/libs/util'
import reply from '@/components/reply'
import { marked } from 'marked'
import { mapState } from 'vuex'
import 'github-markdown-css'

export default {
  name: 'show-article-details',
  components: {
    reply
  },
  computed: {
    ...mapState('d2admin/user', {
      auth: 'info'
    })
  },
  data () {
    return {
      articleId: this.$route.params.id,
      articleDetails: {},
      curPane: 'reply'
    }
  },
  methods: {
    render: marked,
    formatTime: util.time.formatTime,
    /**
     * 获得文章详情
     */
    async getArticleDetails () {
      this.articleDetails = await api.GET_ARTICLE_DETAILS(this.articleId)
      console.log(this.articleDetails)
    },
    /**
     * 跳转到商品详情页面
     */
    showCommodityDetails () {
      if (this.articleDetails.commodity === null) {
        this.$Message.error('该文章没有关联商品！')
      } else {
        this.$router.push({ path: `/commodity/show-details/${this.articleDetails.commodity.id}` })
      }
    },
    /**
     * 复制当前文章链接
     */
    async copyLink () {
      await this.$copyText(window.location.href)
      this.$Message.success('已经成功复制到剪切板！')
    },
    /**
     * 跳转到修改文章的页面
     */
    modifyArticle () {
      this.$router.push({ path: `/article/update/${this.articleId}` })
    },
    /**
     * 点赞
     */
    async clickStar () {
      await api.CLICK_STAR(this.articleId)
      await this.getArticleDetails()
      this.$Message.success('点赞成功')
    },
    /**
     * 取消点赞
     */
    async cancelStar () {
      await api.CANCEL_STAR(this.articleId)
      await this.getArticleDetails()
      this.$Message.success('取消点赞')
    },
    /**
     * 收藏
     */
    async clickCollect () {
      await api.CLICK_COLLECT(this.articleId)
      await this.getArticleDetails()
      this.$Message.success('收藏成功')
    },
    /**
     * 取消收藏
     */
    async cancelCollect () {
      await api.CANCEL_COLLECT(this.articleId)
      await this.getArticleDetails()
      this.$Message.success('取消收藏')
    }
  },
  mounted () {
    this.getArticleDetails()
  }
}
</script>

<style scoped>

.title {
  text-align: center;
  font-size: 40px;
  color: black;
  font-weight: bold;
}
.info {
  text-align: center;
}

.btn {
  text-align: center;
  margin-top: 10px;
}

.author {
  margin-right: 20px;
}

.time {
  margin-right: 20px;
}

.content {
  color: black;
  font-family: "楷体", "Lato", "Helvetica Neue", Helvetica, Arial, sans-serif;
}

.reply {
  margin-top: 10px;
}

</style>
