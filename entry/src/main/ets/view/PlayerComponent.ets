import { displaySync } from "@kit.ArkGraphics2D";
import { MusicControlComponent } from "./MusicControlComponent";
import { curves, window } from "@kit.ArkUI";
import { Logger } from "../utils/Logger";
import { BusinessError } from "@kit.BasicServicesKit";

@Entry
@Component
export struct PlayerComponent{

  @StorageLink('isPlay') @Watch('animationFun') isPlay: boolean = false;
  private panOption: PanGestureOptions = new PanGestureOptions({ direction: PanDirection.Vertical });
  private backDisplaySyncSlow: displaySync.DisplaySync | undefined = undefined;
  @StorageLink('isShowPlay') isShowPlay: boolean = false;
  @StorageLink('topArea') topArea: number = 0;
  @StorageLink('bottomArea') bottomArea: number = 0;
  @State componentHeight: number = 0;
  @StorageLink('deviceHeight') deviceHeight: number = 0;


  animationFun() {
    if (this.isPlay) {
      this.backDisplaySyncSlow?.start();
    } else {
      this.backDisplaySyncSlow?.stop();
    }
  }

  build() {
    Row(){
      Row(){
        Image($r('app.media.song_img'))
          .height('32vp')
          .width('32vp')
          .borderRadius('16vp')
          .margin({right:'12vp'})
          .rotate({angle:0})
          .onAppear(()=>{
            this.animationFun();
          })
        Column() {
          Text('泡沫')
            .fontColor($r('app.color.song_name'))
            .fontSize($r('app.float.song_title_sm'))

          Text('邓紫棋')
            .fontColor($r('app.color.singer'))
            .fontSize($r('app.float.singer_title_sm'))
            .opacity($r('app.float.singer_opacity'))
        }
        .alignItems(HorizontalAlign.Start)
      }
      .layoutWeight(1)
      .onClick(()=>{
        this.isShowPlay = true;
      })

      Blank()
        .onClick(() => {
          this.isShowPlay = true;
        })

      Row(){
        Image(this.isPlay?$r('app.media.ic_play'):$r('app.media.ic_pause') )
          .height('24vp')
          .width('24vp')
          .displayPriority(3)
          .onClick(()=>{
            this.isPlay = !this.isPlay;
          })
        Image($r('app.media.ic_music_list'))
          .height($r('app.float.control_icon_height'))
          .width($r('app.float.control_icon_width'))
          .displayPriority(1)
      }
      .width($r('app.float.play_width_sm'))
      .justifyContent(FlexAlign.End)

    }
    .height('48vp')
    .width('100%')
    .backgroundColor($r('app.color.player_background'))
    .bindContentCover($$this.isShowPlay, this.musicPlayBuilder(), ModalTransition.DEFAULT)
    .padding({
      left: $r('app.float.player_padding'),
      right: $r('app.float.player_padding')
    })
    .position({
      x: 0,
      y: '100%'
    })
    .translate({
      x: 0,
      y: '-48vp'
    })
    .gesture(
      PanGesture(this.panOption)
        .onActionEnd((event?: GestureEvent) => {
          if (event && event.offsetY < -10) {
            this.isShowPlay = true;
          }
        })
    )
  }

  @Builder
  musicPlayBuilder(){
    Column(){
      Column() {
        MusicControlComponent({ isShowPlay: this.isShowPlay })
      }
      .height((100 - this.componentHeight) + '%')
    }
    .height('100%')
    .width('100%')
    .justifyContent(FlexAlign.End)
    .transition(TransitionEffect.translate({ y: 1000 }).animation({ curve: curves.springMotion(0.6, 0.8) }))
    .backgroundColor($r('app.color.player_background'))
    .onAppear(() => {
      window.getLastWindow(getContext(this)).then((windowStage: window.Window) => {
        let area = windowStage.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
        this.topArea = px2vp(area.topRect.height);
        let bottomArea = windowStage.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
        this.bottomArea = px2vp(bottomArea.bottomRect.height);
        Logger.info('bottomArea ' + this.bottomArea)
        if (this.topArea > 0) {
          windowStage.setWindowLayoutFullScreen(true);
        }
        let sysBarProps: window.SystemBarProperties = {
          statusBarContentColor: '#FFFFFF'
        };
        windowStage.setWindowSystemBarProperties(sysBarProps);
      }).catch((error: BusinessError) => {
        Logger.error(`${error.code} + ${error.message}`)
      });
    })
    .onDisAppear(() => {
      this.componentHeight = 0;
      this.isShowPlay = false;
      window.getLastWindow(getContext(this)).then((windowStage: window.Window) => {
        let area = windowStage.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
        let topHeight = px2vp(area.topRect.height);
        if (topHeight > 0) {
          windowStage.setWindowLayoutFullScreen(false);
        }
        let sysBarProps: window.SystemBarProperties = {
          statusBarContentColor: '#000000'
        };
        windowStage.setWindowSystemBarProperties(sysBarProps);
      }).catch((error: BusinessError) => {
        Logger.error(`${error.code} + ${error.message}`)
      });
    })
    .gesture(
      PanGesture(this.panOption)
        .onActionUpdate((event?: GestureEvent) => {
          if (event) {
            let height = event.offsetY / this.deviceHeight * 100;
            this.componentHeight = height;
            if (this.componentHeight < 0) {
              this.componentHeight = 0;
            }
          }
        })
        .onActionEnd(() => {
          if (this.componentHeight > 40) {
            this.isShowPlay = false;
          } else {
            this.componentHeight = 0;
          }
        })
    )
  }
}