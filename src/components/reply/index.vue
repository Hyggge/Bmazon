<template>
  <div>
    <div v-clickoutside="hideReplyBtn" @click="inputFocus" class="my-reply">
      <el-row>
        <!--头像和输入框-->
        <el-col :span="22">
          <el-avatar class="header-img" :size="40" :src="myHeader"></el-avatar>
          <div class="reply-info">
            <div tabindex="0"
              contenteditable="true"
              id="replyInput"
              spellcheck="false"
              placeholder="输入你的回复..."
              class="reply-input"
              @focus="showReplyBtn"
              @input="onDivInput($event)">
            </div>
          </div>
        </el-col>
        <!--按钮-->
        <el-col :span="2">
          <div class="reply-btn-box" v-show="btnShow">
            <el-button class="reply-btn" size="medium" @click="replyToArticle" type="primary">回复</el-button>
          </div>
        </el-col>
      </el-row>
    </div>
    <div v-for="reply in replyList" :key="reply.id" class="author-title reply-father">
      <!--回复者头像-->
      <el-avatar class="header-img" :size="40" :src="reply.image_url != null ? reply.image_url : 'https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png'"></el-avatar>
      <!--回复者信息-->
      <div class="author-info">
        <span class="author-name">{{reply.user__nickname}} </span>
        <span class="author-time"> {{`${reply.floor}楼: ` + (reply.refer === null ? '回复文章' : `回复${reply.refer_floor}楼`)}}</span>
      </div>
      <!--打开回复框的按钮-->
      <div class="icon-btn" style="text-align: right; margin-right: 50px">
        <span @click="openInputBox(reply.floor)">
            <i class="iconfont el-icon-s-comment"></i>
        </span>
        <span @click="closeInputBox(reply.floor)">
            <i class="iconfont el-icon-caret-top"></i>
        </span>
      </div>
      <!--回复内容-->
      <div class="talk-box">
        <p>
          <span v-html="reply.content" class="reply">{{}}</span>
        </p>
      </div>
      <!--对回复进行回复-->
      <div v-if="inputBox[reply.floor] === true" class="my-reply my-comment-reply">
        <el-row>
          <!--头像和输入框-->
          <el-col :span="21">
            <el-avatar class="header-img" :size="40" :src="myHeader"></el-avatar>
            <div class="reply-info">
              <div tabindex="0" contenteditable="true" spellcheck="false" placeholder="输入你的回复..."
                   @input="onDivInput($event)" class="reply-input reply-comment-input"></div>
            </div>
          </el-col>
          <!--确定按钮-->
          <el-col :span="2">
            <div class=" reply-btn-box">
              <el-button class="reply-btn" size="medium" @click="replyToReply(reply.floor)" type="primary">回复
              </el-button>
            </div>
          </el-col>
        </el-row>
      </div>
    </div>
  </div>
</template>

<script>
import api from '@/api'

const clickoutside = {
  // 初始化指令
  bind (el, binding, vnode) {
    function documentHandler (e) {
      // 这里判断点击的元素是否是本身，是本身，则返回
      if (el.contains(e.target)) {
        return false
      }
      // 只有不是本身 才会响应事件
      // 判断指令中是否绑定了函数
      if (binding.expression) {
        // 如果绑定了函数 则调用那个函数，此处binding.value就是handleClose方法
        binding.value(e)
      }
    }

    // 给当前元素绑定个私有变量，方便在unbind中可以解除事件监听
    el.vueClickOutside = documentHandler
    document.addEventListener('click', documentHandler)
  },
  // update() {
  // },
  // vue 弹出框 下面 响应
  unbind (el, binding) {
    // 解除事件监听
    document.removeEventListener('click', el.vueClickOutside)
    delete el.vueClickOutside
  }
}
export default {
  name: 'reply',
  data () {
    return {
      btnShow: false,
      index: '0',
      replyComment: '',
      myName: 'Lana Del Rey',
      myHeader: this.$store.state.d2admin.user.info.headImg,
      myId: 19870621,
      to: '',
      toId: -1,
      replyList: [],
      inputBox: [false]
    }
  },
  props: ['articleId'],
  directives: { clickoutside },
  methods: {
    /**
     * 获取文章所有的回复
     */
    async getReplyList () {
      const res = await api.GET_REPLY_LIST(this.articleId)
      this.replyList = res.replies
      for (const i in this.replyList) {
        this.inputBox.push(false)
      }
      console.log(this.replyList)
      console.log(this.inputBox)
    },
    /**
     * 打开回复框
     */
    openInputBox (floor) {
      this.$set(this.inputBox, floor, true)
    },
    /**
     * 关闭回复框
     */
    closeInputBox (floor) {
      this.$set(this.inputBox, floor, false)
    },
    /**
     * 回复文章
     */
    async replyToArticle () {
      if (!this.replyComment) {
        this.$Message.error('回复不能为空！')
      }
      else {
        const input = document.getElementById('replyInput')
        const data = { content: this.replyComment }
        await api.CREATE_REPLY(this.articleId, data)
        await this.getReplyList()
        this.$Message.success('回复成功！')
        this.replyComment = ''
        input.innerHTML = ''
      }
    },
    /**
     * 回复某个用户的回复
     */
    async replyToReply (floor) {
      if (!this.replyComment) {
        this.$Message.error('回复不能为空！')
      } else {
        const data = {
          content: this.replyComment,
          ref_floor: floor
        }
        await api.CREATE_REPLY(this.articleId, data)
        await this.getReplyList()
        this.$Message.success('回复成功！')
        this.replyComment = ''
        this.$set(this.inputBox, floor, false)
      }
    },
    /**
     * 聚焦于输入框
     */
    inputFocus () {
      var replyInput = document.getElementById('replyInput')
      replyInput.style.padding = '8px 8px'
      replyInput.style.border = '2px solid blue'
      replyInput.focus()
    },
    /**
     * 展示回复按钮
     */
    showReplyBtn () {
      this.btnShow = true
    },
    /**
     * 隐藏恢复按钮
     */
    hideReplyBtn () {
      const replyInput = document.getElementById('replyInput')
      this.btnShow = false
      replyInput.style.padding = '10px'
      replyInput.style.border = 'none'
    },
    /**
     * 捕获输入框中的内容
     */
    onDivInput: function (e) {
      this.replyComment = e.target.innerHTML
    }
  },
  mounted () {
    this.getReplyList()
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
  margin: 5px 0;
}

.my-reply .reply-btn-box .reply-btn {
  position: relative;
  float: right;
  margin-right: 15px;
  margin-bottom: 15px;
}

.my-comment-reply {
  margin-left: 50px;
  margin-top: 10px;
}

.my-comment-reply .reply-input {
  width: 100%;
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

.author-title .reply-box {
  margin: 10px 0 0 50px;
  background-color: #efefef;
}

</style>
