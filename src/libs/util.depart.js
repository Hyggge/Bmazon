const departList = [
  { value: 1, label: '材料科学与工程学院' },
  { value: 2, label: '电子信息工程学院' },
  { value: 3, label: '自动化科学与电器工程学院' },
  { value: 4, label: '能源与动力工程学院' },
  { value: 5, label: '航空科学与工程学院' },
  { value: 6, label: '计算机学院' },
  { value: 7, label: '机械工程及自动化学院' },
  { value: 8, label: '经济管理学院' },
  { value: 9, label: '数学科学学院' },
  { value: 10, label: '生物与医学工程学院' },
  { value: 11, label: '人文社会科学学院' },
  { value: 12, label: '外国语学院' },
  { value: 13, label: '交通科学与工程学院' },
  { value: 14, label: '可靠性与系统工程学院' },
  { value: 15, label: '宇航学院' },
  { value: 16, label: '飞行学院' },
  { value: 17, label: '仪器科学与光电学院' },
  { value: 18, label: '北京学院' },
  { value: 19, label: '物理学院' },
  { value: 20, label: '法学院' },
  { value: 21, label: '软件学院' },
  { value: 23, label: '高等理工学院' },
  { value: 24, label: '中法工程师学院' },
  { value: 25, label: '国际学院' },
  { value: 26, label: '新媒体艺术与设计学院' },
  { value: 27, label: '化学学院' },
  { value: 28, label: '马克思主义学院' },
  { value: 29, label: '人文与社会科学高等研究院' },
  { value: 30, label: '空间与环境学院' },
  { value: 31, label: '无人系统研究院' },
  { value: 32, label: '航空发动机学院' },
  { value: 35, label: '国际通用工程学院' },
  { value: 37, label: '北航学院' },
  { value: 71, label: '传源书院' },
  { value: 73, label: '士谔书院' },
  { value: 74, label: '冯如书院' },
  { value: 75, label: '士嘉书院' },
  { value: 76, label: '守谔书院' },
  { value: 77, label: '致真书院' },
  { value: 79, label: '知行书院' },
  { value: 38, label: '医学科学与工程学院' },
  { value: 39, label: '网络空间安全学院' },
  { value: 41, label: '集成电路科学与工程学院' },
  { value: 42, label: '人工智能研究院' },
  { value: 43, label: '前沿科学技术创新研究院' }
]

const getDepartNameById = function (id) {
  let name = ''
  departList.forEach((item, index) => {
    if (item.value === id) {
      name = item.label
    }
  })
  return name
}

export { getDepartNameById, departList }
