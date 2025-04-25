import { PreferencesUtil } from "../utils/PreferencesUtil";
import { router } from "@kit.ArkUI";
import { MediaService } from "../service/MediaService";

@Entry
@Component
export struct MyAPP {
  @State private scaleNumber: number = 0;  // 初始缩放比例
  @State private opacityNumber: number = 0; // 初始透明度
  @State private rotateNumber: number = 0;  // 初始旋转角度
  // 新增动画配置状态变量
  @State private animationDuration: number = 3000
  private animationInterval: number | null = null;
  // 增加动画状态标识
  @State private isAnimating: boolean = false

  // 添加生命周期方法
  async aboutToAppear(): Promise<void> {
    console.log("开始播放动画");
    this.customAnimation();
  }

  async aboutToDisappear(): Promise<void> {
    console.log("停止播放动画");
    this.clearAnimation()
  }

  private customAnimation() {
    // 先清除已有定时器
    this.clearAnimation()
    this.isAnimating = true;

    // 初始化动画状态
    this.scaleNumber = 0
    this.opacityNumber = 0
    this.rotateNumber = 0

    let startTime = Date.now();
    this.animationInterval = setInterval(() => {
      if (!this.isAnimating) {
        return;
      }
      const elapsedTime = Date.now() - startTime;
      const progress = Math.min(elapsedTime / this.animationDuration, 1) // 限制最大进度为1

      this.updateAnimationState(progress)

      if (progress >= 1) { // 正确判断动画完成条件
        this.clearAnimation()
        console.log("动画完整完成")
        this.checkInitialLoginStatus()
      }
    }, 16);
  }

  private clearAnimation() {
    if (this.animationInterval) {
      clearInterval(this.animationInterval)
      this.animationInterval = null
    }
    this.isAnimating = false
  }

  private updateAnimationState(progress: number) {
    // 修复缩放参数应用
    let scaleProgress = progress
    this.scaleNumber = scaleProgress > 1 ? 2 - scaleProgress : scaleProgress
    this.opacityNumber = Math.pow(progress, 0.8)
    this.rotateNumber = progress * 360
    console.log(`进度: ${progress.toFixed(2)}, 缩放: ${this.scaleNumber.toFixed(2)}`)
  }

  // 新增token检查方法
  private async checkInitialLoginStatus(): Promise<void> {
      // 添加100ms延迟确保动画渲染完成
    await new Promise<void>(resolve => setTimeout(resolve, 1000))


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
          MediaService.getInstance()
          router.replaceUrl({ url: 'pages/MainPage' });
      } else {
          // 没有找到 Token，跳转到登录页面
          router.replaceUrl({ url: 'pages/LoginPage' });
      }
  }


  build() {
    Column() {
      // 应用LOGO
      Image($r('app.media.app')) // 请将图片放入media目录
        .width('100%')
        .height('100%')
        .scale({ x: this.scaleNumber, y: this.scaleNumber})
        .opacity(this.opacityNumber)
        .rotate({ angle: this.rotateNumber })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White)
  }
}
