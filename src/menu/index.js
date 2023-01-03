import { uniqueId } from 'lodash'

/**
 * @description 给菜单数据补充上 path 字段
 * @description https://github.com/d2-projects/d2-admin/issues/209
 * @param {Array} menu 原始的菜单数据
 */
function supplementPath (menu) {
  return menu.map(e => ({
    ...e,
    path: e.path || uniqueId('d2-menu-empty-'),
    ...e.children ? {
      children: supplementPath(e.children)
    } : {}
  }))
}

export const menuHeader = supplementPath([
  { path: '/index', title: '首页', icon: 'home' }
])

export const menuAside = supplementPath([
  {
    path: '/index',
    title: '首页',
    icon: 'home'
  },
  {
    path: '/commodity/show-all',
    title: '北航商城',
    icon: 'shopping-cart'
  },
  {
    title: '种草分享',
    icon: 'bookmark',
    children: [
      { path: '/article/show-all', title: '所有文章', icon: 'tags' },
      { path: '/article/create', title: '写文章', icon: 'pencil' }
    ]
  },
  {
    path: '/user/orders',
    title: '我的订单',
    icon: 'truck'
  },
  {
    path: '/user/statistic',
    title: '消费统计',
    icon: 'bar-chart'
  },
  {
    title: '我的店铺',
    icon: 'home',
    children: [
      { path: '/shop/details', title: '店铺信息', icon: 'balance-scale' },
      { path: '/shop/goods', title: '店铺商品', icon: 'shopping-bag' },
      { path: '/shop/orders', title: '店铺订单', icon: 'rocket' },
      { path: '/shop/create', title: '创建店铺', icon: 'cube' }
    ]
  },
  {
    path: '/user/details',
    title: '个人中心',
    icon: 'user'
  },
  {
    title: '管理',
    icon: 'cog',
    children: [
      { path: '/admin/show-users', title: '用户列表', icon: 'bar-chart' },
      { path: '/admin/show-shops', title: '店铺列表', icon: 'line-chart' },
      { path: '/admin/show-orders', title: '订单列表', icon: 'line-chart' },
      { path: '/admin/show-user-certifications', title: '学生认证请求列表', icon: 'line-chart' },
      { path: '/admin/show-logs', title: '日志列表', icon: 'bar-chart' }
    ]
  }
])
