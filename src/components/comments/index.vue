<template>
  <div>
    <div v-for="(item,i) in commentList" :key="i" class="author-title reply-father">
      <el-avatar class="header-img" :size="40" :src="item.user_image_url != null ? item.user_image_url : 'https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png'"></el-avatar>
      <div class="author-info">
        <span class="author-name">{{item.order__user__nickname}}</span>
        <span class="author-time" >
          {{formatTime(item.comment_time)}}
          <span v-if="item.parameters.length !== 0">
            <el-tag v-for="param in item.parameters" size="mini" type="info" style="margin-right: 5px">{{param}}</el-tag>
          </span>
        </span>
        <span class="author-time">
        </span>
      </div>

      <div class="talk-box">
        <p>
          <span class="reply">{{item.content === '' ? '暂无评价' : item.content}}</span>
        </p>
        <el-row v-if="item.image_urls.length !== 0" :gutter="10" class="img">
          <el-col v-for="(url, urlIndex) in item.image_urls" :key="urlIndex" :span="5">
            <img  :src="url" alt="" style="width: 100%; height: 100px">
          </el-col>
        </el-row>
      </div>
    </div>
  </div>
</template>

<script>

import api from '@/api'
import util from '@/libs/util'

export default {
  name: 'ArticleComment',
  props: ['commodityId'],
  data () {
    return {
      commentList: {},
      filterTotalCnt: '',
      currentPage: 1
    }
  },
  methods: {
    formatTime: util.time.formatTime,
    async getCommentList () {
      const res = await api.GET_COMMENT_LIST_OF_COMMODITY(this.commodityId)
      this.commentList = res.data
      this.filterTotalCnt = res.filter_count
      console.log(this.filterTotalCnt)
      console.log(this.commentList)
    }
  },
  mounted () {
    this.getCommentList()
  }
}
</script>

<style scoped lang="css">
.my-reply {
  padding: 10px;
  background-color: #fafbfc;
}

.my-reply .header-img {
  display: inline-block;
  vertical-align: top;
}

.my-reply .reply-info {
  display: inline-block;
  margin-left: 5px;
  width: 90%;
}

@media screen and (max-width: 1200px) {
  .my-reply .reply-info {
    width: 80%;
  }
}

.my-reply .reply-info .reply-input {
  min-height: 20px;
  line-height: 22px;
  padding: 10px 10px;
  color: #ccc;
  background-color: #fff;
  border-radius: 5px;
}

.my-reply .reply-info .reply-input:empty:before {
  content: attr(placeholder);
}

.my-reply .reply-info .reply-input:focus:before {
  content: none;
}

.my-reply .reply-info .reply-input:focus {
  padding: 8px 8px;
  border: 2px solid #00f;
  box-shadow: none;
  outline: none;
}

.my-reply .reply-btn-box {
  height: 25px;
  margin: 10px 0;
}

.my-reply .reply-btn-box .reply-btn {
  position: relative;
  float: right;
  margin-right: 15px;
}

.my-comment-reply {
  margin-left: 50px;
}

.my-comment-reply .reply-input {
  width: flex;
}

.author-title:not(:last-child) {
  border-bottom: 1px solid rgba(178, 186, 194, 0.3);
}

.author-title {
  margin-top: 1rem;
  padding: 10px;
}

.author-title .header-img {
  display: inline-block;
  vertical-align: top;
}

.author-title .author-info {
  display: inline-block;
  margin-left: 5px;
  width: 60%;
  height: 40px;
  line-height: 20px;
}

.author-title .author-info > span {
  display: block;
  cursor: pointer;
  overflow: hidden;
  white-space: nowrap;
  text-overflow: ellipsis;
}

.author-title .author-info .author-name {
  color: #000;
  font-size: 18px;
  font-weight: bold;
}

.author-title .author-info .author-time {
  font-size: 14px;
}

.author-title .icon-btn {
  width: 30%;
  padding: 0 !important;
  float: right;
}

@media screen and (max-width: 1200px) {
  .author-title .icon-btn {
    width: 20%;
    padding: 7px;
  }
}

.author-title .icon-btn > span {
  cursor: pointer;
}

.author-title .icon-btn .iconfont {
  margin: 0 5px;
}

.author-title .talk-box {
  margin: 0 50px;
}

.author-title .talk-box > p {
  margin: 0;
}

.author-title .talk-box .reply {
  font-size: 16px;
  color: #000;
}
.author-title .talk-box .img {
  font-size: 16px;
  color: #000;
  margin: 5px;
}

.author-title .reply-box {
  margin: 10px 0 0 50px;
  background-color: #efefef;
}


</style>
