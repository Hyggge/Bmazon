<template>
  <d2-container>
    <template v-slot:header>
      <!--輸入题目-->
      <div style="text-align: center">
        <el-input
          type="text"
          v-model="article.title"
          placeholder="请输入文章标题..."
          style="width: 500px; cursor: pointer"
        ></el-input>
        <el-button type="warning" style="margin-left: 10px" @click="updateArticle" >修改</el-button>
      </div>
    </template>
    <!--推荐商品的连接-->
    <el-input size="mini" placeholder="请输入推荐的商品链接...(可选)" v-model.trim="article.commodityUrl"></el-input>
    <!--富文本编辑器-->
    <mavon-editor v-model="article.content" ref=md class="editor" @imgAdd="imgAdd" @imgDel="imgDel" @change="changeContent"/>
  </d2-container>
</template>

<script>
import { mapState } from 'vuex'
import api from '@/api'

export default {
  name: 'article-update',
  computed: {
    ...mapState('d2admin/user', {
      auth: 'info'
    })
  },
  data () {
    return {
      articleId: this.$route.params.id,
      article: {
        title: '',
        content: '',
        commodityUrl: ''
      }
    }
  },
  methods: {
    /**
     * 获得商品详情
     */
    async getArticleDetails () {
      const res = await api.GET_ARTICLE_DETAILS(this.articleId)
      this.article.title = res.title
      this.article.content = res.content
      const base = window.location.href.split('#')[0] + '#/'
      if (res.commodity !== null) this.article.commodityUrl = base + 'commodity/show-details/' + res.commodity.id
      console.log(this.article)
    },
    /**
     * 修改文章
     */
    async updateArticle () {
      console.log(this.article.content)
      if (this.article.title === '') {
        this.$Message.error('文章标题不能为空！')
      } else if (this.article.content === '') {
        this.$Message.error('文章内容不能为空！')
      } else if (this.article.commodityUrl !== '' &&
        new RegExp('^' + window.location.href.split('#')[0] + '#/commodity/show-details/\\d+$').test(this.article.commodityUrl) === false) {
        this.$Message.error('不是有效的商品连接！')
      } else {
        const data = {
          title: this.article.title,
          content: this.article.content,
          commodity: this.article.commodityUrl === '' ? null : parseInt(this.article.commodityUrl.split('/').pop())
        }
        console.log(data)
        await api.MODIFY_ARTICLE(this.articleId, data)
        await this.$router.push({ path: `/article/show-details/${this.articleId}` })
        this.$Message.success('修改成功！')
      }
    },
    /**
     * 增加图片
     */
    async imgAdd (pos, file) {
      const res = await api.UPLOAD_FILE(file)
      console.log(res)
      const imageId = res.id
      console.log(imageId)
      // 直接向服务器发起请求返回的是临时链接
      // const ret = await api.DOWNLOAD_FILE(imageId)
      // const imageUrl = ret.url
      // console.log(imageUrl)
      // 改用拼接而成的永久连接
      const imageUrl = process.env.VUE_APP_API + '/api/file/download/' + imageId
      this.$refs.md.$img2Url(pos, imageUrl)
    },
    /**
     * 删除图片
     */
    async imgDel (pos) {
      // DO NOTHING
    }
  },
  mounted () {

    this.getArticleDetails()
  }
}
</script>

<style scoped>
.editor {
  height: 480px;
}
</style>
