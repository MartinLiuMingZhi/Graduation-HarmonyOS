@Builder
export function PrivacyPolicyPageBuilder(){
   PrivacyPolicyPage()
}

@Component
@Preview
export struct PrivacyPolicyPage {


  build() {
    NavDestination(){
      Scroll() {
        Column({ space: 15 }) {
          Text('隐私政策')
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Center)
            .width('100%')

          Text('欢迎使用本应用。我们非常重视您的隐私权。以下是我们的隐私政策说明：')
            .fontSize(16)
            .textAlign(TextAlign.Start)
            .width('90%')
            .padding({ left: 10 })

          Text('1. 信息收集与使用\n\n我们仅在提供服务所必需的情况下收集您的个人信息，包括但不限于：\n- 注册时提供的邮箱地址、用户名等；\n- 使用过程中产生的操作记录。\n我们不会将这些信息用于任何未明确告知的目的。')
            .fontSize(16)
            .textAlign(TextAlign.Start)
            .width('90%')
            .padding({ left: 10 })

          Text('2. 数据存储与安全\n\n我们采取合理的技术手段保护您的数据免受未经授权的访问、篡改或泄露。所有敏感信息均加密存储。')
            .fontSize(16)
            .textAlign(TextAlign.Start)
            .width('90%')
            .padding({ left: 10 })

          Text('3. 第三方披露\n\n除非法律要求或您授权，我们不会向第三方披露您的个人信息。')
            .fontSize(16)
            .textAlign(TextAlign.Start)
            .width('90%')
            .padding({ left: 10 })

          Text('4. 您的权利\n\n您可以随时查看、修改或删除您的个人信息。如需协助，请联系客服。')
            .fontSize(16)
            .textAlign(TextAlign.Start)
            .width('90%')
            .padding({ left: 10 })

          Text('5. 隐私政策更新\n\n我们可能不时更新本隐私政策。变更将通过应用内公告或邮件通知您。')
            .fontSize(16)
            .textAlign(TextAlign.Start)
            .width('90%')
            .padding({ left: 10 })

          Text('最后更新日期：2025年4月5日')
            .fontSize(14)
            .fontColor('#888')
            .textAlign(TextAlign.End)
            .width('90%')
            .margin({ right: 20 })
        }
        .padding({ left: 10, right: 10 })
        .width('100%')
      }
      .scrollBar(BarState.Off)
      .width('100%')
      .height('100%')
    }

  }
}
