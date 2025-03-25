import { PreferencesUtil } from "../utils/PreferencesUtil";
import { router } from "@kit.ArkUI";

@Entry
@Component
export struct MyAPP {
  // 添加生命周期方法
  async aboutToAppear(): Promise<void> {
    await this.checkInitialLoginStatus();
  }

  // 新增token检查方法
  private async checkInitialLoginStatus(): Promise<void> {
      const token = await PreferencesUtil.getAsync('token');
      const tokenExpiration:string = await PreferencesUtil.getAsync('tokenExpiration');
      if (token && tokenExpiration) {
          const currentTime = new Date().getTime();
          if (currentTime > parseInt(tokenExpiration)) {
              // Token 已过期，清除本地存储的 Token 并跳转到登录页面
              await PreferencesUtil.deleteAsync('token');
              router.replaceUrl({ url: 'pages/LoginPage' });
              return;
          }
          router.replaceUrl({ url: 'pages/MainPage' });
      } else {
          // 没有找到 Token，跳转到登录页面
          router.replaceUrl({ url: 'pages/LoginPage' });
      }
  }

  build() {
    // 保持空白或基础布局
    Column() {
      // 可添加加载动画等过渡元素
      LoadingProgress()
        .width(100)
        .height(100)
    }
    .width('100%')
    .height('100%')
  }
}
