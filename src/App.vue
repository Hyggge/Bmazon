<template>
  <div id="app">
    <router-view/>
  </div>
</template>

<script>
import util from '@/libs/util'
import { menuAside } from '@/menu'

export default {
  name: 'app',
  watch: {
    '$i18n.locale': 'i18nHandle'
  },
  created () {
    this.i18nHandle(this.$i18n.locale)
  },
  methods: {
    i18nHandle (val, oldVal) {
      util.cookies.set('lang', val)
      document.querySelector('html').setAttribute('lang', val)
    }
  },
  async mounted () {
    // 从持久化存储中加载用户信息
    await this.$store.dispatch('d2admin/user/load', null, { root: true })
    if (this.$store.state.d2admin.user.info.role === 1) {
      menuAside.pop()
    }
    // 设置侧边栏菜单
    this.$store.commit('d2admin/menu/asideSet', menuAside)
    // 初始化菜单搜索功能
    this.$store.commit('d2admin/search/init', menuAside)
  }
}
</script>

<style lang="scss">
@import '~@/assets/style/public-class.scss';
</style>
