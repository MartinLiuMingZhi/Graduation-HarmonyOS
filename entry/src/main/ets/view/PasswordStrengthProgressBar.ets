@Component
export struct PasswordStrengthProgressBar {
  @Prop passwordStrength: string = '弱'

  build() {
    Row({ space: 5 }) {
      // 弱密码进度条（红色）
      Progress({ value: this.getSegmentValue('弱'), total: 100, type: ProgressType.Linear })
        .width('33%')
        .height(10)
        .color('#FF4D4F') // 红色表示弱密码

      // 中等密码进度条（黄色）
      Progress({ value: this.getSegmentValue('中'), total: 100, type: ProgressType.Linear })
        .width('33%')
        .height(10)
        .color('#FAAD14') // 黄色表示中等密码

      // 强密码进度条（绿色）
      Progress({ value: this.getSegmentValue('强'), total: 100, type: ProgressType.Linear })
        .width('33%')
        .height(10)
        .color('#52C41A') // 绿色表示强密码
    }
    .width('90%')
    .justifyContent(FlexAlign.SpaceAround)
  }

  // 根据当前密码强度值计算每段进度条显示的值
  private getSegmentValue(level: string): number {
    switch (this.passwordStrength) {
      case '强':
        return level === '强' ? 100 : 100
      case '中':
        return level === '强' ? 0 : 100
      case '弱':
        return level === '弱' ? 100 : 0
      default:
        return 0
    }
  }
}
