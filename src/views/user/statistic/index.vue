<template>
  <d2-container>
    <template v-slot:header>
      <el-row>
        <el-col :span="3"><h3>个人消费统计</h3></el-col>
        <el-col :span="4">
          <el-date-picker
            style="width: 150px"
            size="mini"
            :clearable="false"
            v-model="year"
            type="year"
            value-format="yyyy"
            placeholder="选择年">
          </el-date-picker>
        </el-col>
      </el-row>
    </template>

    <el-row style="margin-top: 30px; text-align: center">
      <el-col style="text-align: center">
        <div id="bar" style="width:700px; height:420px; text-align: center"></div>
      </el-col>
    </el-row>
  </d2-container>
</template>

<script>
import api from '@/api'
// import echarts from "_echarts@5.4.1@echarts";

export default {
  name: 'statistic',
  data () {
    return {
      year: '2022'
    }
  },
  watch: {
    year (newVal, oldVal) {
      this.getConsumeStatic()
    }
  },
  methods: {
    async getConsumeStatic () {
      const echarts = require('echarts')
      const res = await api.GET_USER_CONSUME_STATISTIC_PIC(this.year, this.$store.state.d2admin.user.info.id)
      const chart = echarts.init(document.getElementById('bar'), 'white', { renderer: 'canvas' })
      chart.setOption(res)
    }
  },

  mounted () {
    this.getConsumeStatic()
  }
}
</script>

<style scoped>

</style>
