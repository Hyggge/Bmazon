<template>
  <div class="login-layout">
    <div class="left-part">
      <img class="left-pic" src="../../../assets/img/web_shopping.svg" alt="" />
    </div>
    <div class="right-part">
      <div class="right-container">
        <span class="sign-in">登录</span>
        <div class="container" @keydown.enter="onSubmit">
          <el-input
            prefix-icon="el-icon-user-solid"
            v-model.trim="username"
            placeholder="请输入用户名"
            class="my-el-input"
          >
          </el-input>

          <el-input
            prefix-icon="el-icon-lock"
            v-model.trim="password"
            placeholder="请输入密码"
            class="my-el-input"
            show-password
          >
          </el-input>
          <span class="go-to-register" @click="goToRegister"
          >没有账号，去注册</span
          >

          <div style="width: 100%; display: flex" @click="onSubmit">
            <el-button class="my-el-button" type="primary"> 登录 </el-button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapActions } from 'vuex'

export default {
  name: 'Login',
  data () {
    return {
      username: '',
      password: ''
    }
  },
  methods: {
    ...mapActions('d2admin/account', [
      'login'
    ]),

    goToRegister () {
      this.$router.push({ name: 'register' })
    },

    checkUsername () {
      if (this.username === '' || this.username === null) {
        this.$Message.error('用户名不能为空！')
        return false
      }
      return true
    },

    checkPassword () {
      if (this.password === '' || this.password === null) {
        this.$Message.error('密码不能为空！')
        return false
      }
      return true
    },

    onSubmit () {
      if (!this.checkUsername() || !this.checkPassword()) return
      const userAuth = {
        username: this.username.trim(),
        password: this.password.trim()
      }
      this.login(userAuth)
        .then(() => {
          this.$Message.success('登陆成功！')
          this.$router.replace(this.$route.query.redirect || '/')
        })
        .catch((err) => {
          console.log(err.response.data)
          let errMsg = err.response.data.error_msg
          errMsg = errMsg.slice(errMsg.indexOf(':') + 1)
          this.$Message.error(errMsg)
        })
    }
  }
}
</script>

<style scoped>
.login-layout {
  width: 100%;
  min-height: 100vh;
  background: linear-gradient(90deg, white, #E2F5F7);
  display: flex;
  font-family: "Helvetica Neue", "Helvetica", "Arial", "PingFang SC", "Hiragino Sans GB", "Heiti SC", "Microsoft YaHei", "WenQuanYi Micro Hei", sans-serif !important;;
}

.left-part {
  width: 50%;
  min-height: 100vh;
}

.right-part {
  width: 50%;
  min-height: 100vh;
}

.logo-and-name {
  position: absolute;
  top: 30px;
  left: 75px;
  width: 96px;
  height: 72px;
}

.logo {
  width: 96px;
}

.left-pic {
  width: 90%;
  height: 90%;
  left: 10%;
  margin-top: 10px;
  position: relative;
  object-fit: contain;
}

.right-container {
  position: absolute;
  top: 50%;
  right: 50%;
  margin-right: -650px;
  background: #FFF;
  border-radius: 32px;
  box-shadow: 0 16px 32px 0 rgb(0 0 0 / 8%);
  transform: translateY(-50%);
  padding: 64px;
  width: 92%;
  max-width: 488px;
}

.sign-in {
  font-size: 40px;
  line-height: 48px;
  margin-bottom: 32px;
  font-weight: bold;
}

.switch-content {
  width: 100%;
  height: 100%;
  margin-top: 20px;
}

.my-el-input {
  margin: 30px auto 0 auto;
}

.my-el-input >>>.el-input__inner {
  font-size: 23px;
  line-height: 28px;
  height: 50px;
}

.my-el-input >>>.el-input__wrapper{
  border-radius: 25px;
}

.my-el-button {
  width: 150px;
  height: 50px;
  color: white;
  font-size: 23px;
  line-height: 28px;
  border-radius: 30px;
  margin: 20px auto 0 auto;
}

.my-el-button:hover {
  color: lightskyblue;
}

.go-to-register {
  float: right;
  margin-top: 5px;
  cursor: pointer;
}

.go-to-register:hover {
  color: lightskyblue;
}


</style>
