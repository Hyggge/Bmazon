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
        <el-button type="success" style="margin-left: 10px" @click="createArticle" >发布</el-button>
      </div>
    </template>
    <!--推荐商品的连接-->
    <el-input size="mini" placeholder="请输入推荐的商品链接...(可选)" v-model.trim="article.commodityUrl"></el-input>
    <!--富文本编辑器-->
    <mavon-editor v-model="article.content" ref=md class="editor" @imgAdd="imgAdd" @imgDel="imgDel" @change="changeContent"/>
  </d2-container>
</template>

<script>
import util from '@/libs/util.js'
import api from '@/api'

export default {
  name: 'article-create',
  data () {
    return {
      article: {
        title: '',
        content: '',
        commodityUrl: ''
      }
    }
  },
  methods: {
    /**
     * 发布文章
     */
    async createArticle () {
      console.log(this.article.content)
      if (this.article.title === '') {
        this.$Message.error('文章标题不能为空！')
      } else if (this.article.content === '') {
        this.$Message.error('文章内容不能为空！')
      } else if (this.article.commodityUrl !== '' &&
        new RegExp('^' + window.location.href.split('#')[0] + '#/commodity/show-details/\\d+$').test(this.article.commodityUrl) === false) {
        this.$Message.error('不是有效的商品链接！')
      } else {
        const data = {
          title: this.article.title,
          content: this.article.content,
          commodity_id: this.article.commodityUrl === '' ? null : parseInt(this.article.commodityUrl.split('/').pop())
        }
        console.log(data)
        await api.CREATE_ARTICLE(data)
        await this.$router.push({ path: '/article/show-all' })
        this.$Message.success('发布成功！')
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
    /**
     * 实时获取渲染后的文档
     */
    // changeContent (value, render) {
    //   this.article.render = render
    //   console.log(render)
    //   console.log('!!!' + this.article.content)
    // }
  }
}
</script>

<style scoped>
.editor {
  height: 480px;
}
</style>
