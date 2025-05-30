import { CardComponent } from "./CardComponent";

@Builder
export function AboutPageBuilder() {
   AboutPage()
}


@Component
export struct AboutPage {
  @StorageLink('pathStack') pathStack: NavPathStack = new NavPathStack();

  build() {
    NavDestination() {
      Scroll(){
        Column({ space: 20 }) {
          // 应用信息卡片
          CardComponent({
            title: '应用信息',
            items: [
              { label: '应用名称', value: 'Harmony Music' },
              { label: '版本号', value: 'v1.0.0' },
              { label: '开发者', value: '曦臣' },
              { label: '学校', value: '长沙理工大学计算机学院' }
            ],
          })

          // 项目简介卡片
          CardComponent({
            title: '项目简介',
            content: '这是一个基于 HarmonyOS 开发的音乐类应用程序，旨在展示 HarmonyOS 的基础功能与开发流程。支持音乐播放、社区互动、用户设置等功能。'
          })

          // 开发背景卡片
          CardComponent({
            title: '开发背景',
            content: '本项目为毕业设计作品，主要用于学习 HarmonyOS 开发技术，掌握 ArkTS、ArkUI 组件化开发、网络请求、状态管理等核心技能。'
          })

          // 第三方依赖
          CardComponent({
            title: '使用技术栈',
            items: [
              { label: '开发语言', value: 'ArkTS' },
              { label: 'UI 框架', value: 'ArkUI' },
              { label: '网络请求', value: 'axios' },
              { label: '图标库', value: '@ohos/svg' }
            ]
          })

        }
        .width('100%')
        .padding({ top: 10, bottom: 30 })
        .backgroundColor('#F5F5F5')
      }
      .width('100%')
      .height('100%')
      .scrollBar(BarState.Off)
    }
    .title('关于')
  }
}