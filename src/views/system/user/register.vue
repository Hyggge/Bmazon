<template>
  <div class='register-layout'>
    <div class='left-part'>
      <img src='../../../assets/img/window_shopping.svg' class='left-pic' alt='' />
    </div>
    <div class='right-part'>
      <div class='right-container'>
        <span class='register-in'>注册</span>
        <div style='margin-top: 20px' @keydown.enter='onSubmit'>
          <el-input
            prefix-icon="el-icon-user-solid"
            class='my-el-input'
            v-model.trim='username'
            placeholder='请输入用户名'
            @blur = 'checkDupUsername'
            style='margin-bottom: 20px'
          >
          </el-input>

          <el-input
            prefix-icon="el-icon-lock"
            v-model.trim='password'
            class='my-el-input'
            placeholder='请输入密码'
            show-password
            style='margin-bottom: 20px'
          >
          </el-input>

          <el-input
            prefix-icon="el-icon-lock"
            class='my-el-input'
            v-model.trim='confirm'
            placeholder='再次输入并确认密码'
            show-password
            style='margin-bottom: 20px'
          >
          </el-input>

          <el-input
            prefix-icon="el-icon-lollipop"
            class='my-el-input'
            v-model.trim='nickname'
            placeholder='请输入昵称'
            style='margin-bottom: 20px'
          >
          </el-input>

          <el-input
            prefix-icon="el-icon-message"
            class='my-el-input'
            v-model.trim='email'
            placeholder='请输入邮箱'
            style='margin-bottom: 5px'
          >
          </el-input>

          <span class='go-to-login' @click='goToLogin'> 已有帐号，去登录 </span>

          <div style='width: 100%; display: flex'>
            <el-button type='primary' class='my-el-button' @click='onSubmit'>
              注册
            </el-button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import api from '@/api'

export default {
  name: 'Register',
  data () {
    return {
      username: '',
      password: '',
      confirm: '',
      nickname: '',
      email: ''
    }
  },
  methods: {
    goToLogin () {
      this.$router.push({ name: 'login' })
    },
    checkDupUsername () {
      if (this.username !== '') {
        api.CHECK_DUP_USERNAME(this.username)
          .then((res) => {
            if (res.exist === true) {
              this.$Message.error('用户名已存在！')
            }
          })
          .catch((err) => {
            console.log(err)
          })
      }
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
      } else if (this.password !== this.confirm) {
        this.$Message.error('两次输入密码不一致！')
        return false
      }
      return true
    },
    checkEmail () {
      const pattern =
        /^[a-zA-Z0-9]+([-_.][A-Za-zd]+)*@([a-zA-Z0-9]+[-.])+[A-Za-zd]{2,5}$/
      if (this.email === '' || this.email === null) {
        this.$Message.error('邮箱不能为空！')
      }
      if (!pattern.test(this.email)) {
        this.$Message.error('邮箱格式不正确！')
        return false
      }
      return true
    },
    checkNickname () {
      if (this.nickname === '' || this.nickname === null) {
        this.$Message.error('昵称不能为空！')
        return false
      }
      return true
    },
    onSubmit () {
      if (this.checkUsername() === false) return
      if (this.checkPassword() === false) return
      if (this.checkNickname() === false) return
      if (this.checkEmail() === false) return
      const params = {
        username: this.username,
        password: this.password,
        nickname: this.nickname,
        email: this.email
      }
      api.USER_REGISTER(params)
        .then((res) => {
          this.$Message.success('注册成功！')
          this.$router.push({ name: 'login' })
        })
        .catch((err) => {
          this.$Message.warning('用户名已被注册！')
        })
    }
  }
}
</script>

<style scoped>
.register-layout {
  width: 100%;
  min-height: 100vh;
  background: linear-gradient(90deg, white, #E2F5F7);
  display: flex;
  font-family: "Helvetica Neue", "Helvetica", "Arial", "PingFang SC", "Hiragino Sans GB", "Heiti SC", "Microsoft YaHei", "WenQuanYi Micro Hei", sans-serif !important;
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
  top: 45%;
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

.register-in {
  font-size: 40px;
  line-height: 48px;
  margin-bottom: 32px;
  font-weight: bold;
}
.my-el-input {
  margin: 5px auto 0 0;
}

.my-el-input >>>.el-input__inner {
  font-size: 20px;
  line-height: 23px;
  height: 40px;
}

.my-el-input >>>.el-input__wrapper {
  border-radius: 25px;
}

.send-button {
  width: 25%;
  height: 40px;
  margin-top: 5px;
  margin-right: 0;
  border-radius: 30px;
}

.go-to-login {
  float: right;
  margin-top: 5px;
  cursor: pointer;
}

.go-to-login:hover {
  color: lightskyblue;
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

</style>
