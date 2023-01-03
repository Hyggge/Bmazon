
const time = {}

time.formatTime = function (str) {
  const info = str.split('T')
  const date = info[0].split('-')
  const time = info[1].split(/[.Z]/)[0]
  return date[0] + '年' + date[1] + '月' + date[2] + '日  ' + time
}

export default time
