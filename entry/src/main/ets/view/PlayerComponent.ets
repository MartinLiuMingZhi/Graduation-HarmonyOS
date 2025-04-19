import { displaySync } from "@kit.ArkGraphics2D";
import { MusicControlComponent } from "./MusicControlComponent";
import { curves, window } from "@kit.ArkUI";
import { Logger } from "../utils/Logger";
import { BusinessError } from "@kit.BasicServicesKit";
import { SongItem } from "../viewmodel/SongItem";
import { MediaService } from "../service/MediaService";

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
  @StorageLink('songList') songList: SongItem[] = [];
  @StorageProp('selectIndex') selectIndex: number = 0;
  @State imageRotate: number = 0;
  @State isPlaylistVisible: boolean = false; // 新增状态变量，用于控制播放列表的显示与隐


  private drawFrame: (value: displaySync.IntervalInfo) => void = (value: displaySync.IntervalInfo) => {
    if (this.imageRotate >= 360 ) {
      this.imageRotate = 0;
    }
    this.imageRotate += 1;
  };

  animationFun() {
    if (this.isPlay) {
      this.backDisplaySyncSlow?.start();
    } else {
      this.backDisplaySyncSlow?.stop();
    }
  }

  aboutToAppear() {
    let range : ExpectedFrameRateRange = {
      expected: 30,
      min: 0,
      max: 30
    };

    this.backDisplaySyncSlow = displaySync.create();
    this.backDisplaySyncSlow.setExpectedFrameRateRange(range);
    this.backDisplaySyncSlow.on('frame', this.drawFrame);

    console.log('Current isShowPlay state:', this.isShowPlay);
  }

  aboutToDisappear(): void {
    this.backDisplaySyncSlow?.off('frame', this.drawFrame);
  }

  build() {
    Row(){
      Row(){
        Image(this.songList[this.selectIndex]?.label || $r('app.media.ic_default_cover'))
          .height('32vp')
          .width('32vp')
          .borderRadius('16vp')
          .margin({right:'12vp'})
          .rotate({angle:0})
          .onAppear(()=>{
            if (this.songList.length > 0) { // (2) 增加数组长度校验
              this.animationFun();
            }
          })
        Column() {
          Text(this.songList[this.selectIndex]?.title ?? '未知标题')
            .fontColor($r('app.color.song_name'))
            .fontSize($r('app.float.song_title_sm'))

          Text(this.songList[this.selectIndex]?.singer ?? '未知歌手')
            .fontColor($r('app.color.singer'))
            .fontSize($r('app.float.singer_title_sm'))
            .opacity($r('app.float.singer_opacity'))
        }
        .alignItems(HorizontalAlign.Start)
      }
      .layoutWeight(1)

      Blank()

      Row(){
        Image($r('app.media.ic_previous'))
          .height($r('app.float.control_icon_height'))
          .width($r('app.float.control_icon_width'))
          .margin({ right: $r('app.float.control_icon_margin') })
          .displayPriority(2)
          .onClick(() => MediaService.getInstance().playPrevious())

        Image(this.isPlay?$r('app.media.ic_play'):$r('app.media.ic_pause') )
          .height('24vp')
          .width('24vp')
          .displayPriority(3)
          .onClick(()=>{
            if (MediaService.getInstance().getFirst()) {
              MediaService.getInstance().loadAssent(0);
            } else {
              this.isPlay ? MediaService.getInstance().pause() : MediaService.getInstance().play();
            }
          })
        Image($r('app.media.ic_next'))
          .height($r('app.float.control_icon_height'))
          .width($r('app.float.control_icon_width'))
          .margin({
            right: $r('app.float.control_icon_margin'),
            left: $r('app.float.control_icon_margin')
          })
          .displayPriority(2)
          .onClick(() => MediaService.getInstance().playNextAuto(true))

        Image($r('app.media.ic_music_list'))
          .height($r('app.float.control_icon_height'))
          .width($r('app.float.control_icon_width'))
          .displayPriority(1)
          .onClick(() => {
            this.isShowPlay = false; // 隐藏音乐控制模态框
            this.isPlaylistVisible = true; // 点击图标时显示播放列表
            console.log('isPlaylistVisible:', this.isPlaylistVisible);
            console.log("isShowPlay",`${this.isShowPlay}`)
          })
          .bindSheet($$this.isPlaylistVisible, this.playlistBuilder(),{
            height: '80%',
            dragBar: true,
            onDisappear: () => {
              console.log('bindSheet onDisappear, isShowPlay:', this.isShowPlay);
              this.isPlaylistVisible = false; // 隐藏播放列表
            },
          })
      }
      .width($r('app.float.play_width_sm'))
      .justifyContent(FlexAlign.End)
      .layoutWeight(1)

    }
    .height('48vp')
    .width('100%')
    .onClick(()=>{
      this.isPlaylistVisible = false; // 隐藏播放列表模态框
      this.isShowPlay = true;
      console.log("isShowPlay",`${this.isShowPlay}`)
      console.log("isPlaylistVisible", this.isPlaylistVisible)
    })
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
            this.isPlaylistVisible = false; // 隐藏播放列表模态框
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
      console.log('musicPlayBuilder onAppear');
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
      console.log('musicPlayBuilder onDisAppear');
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

  @Builder
  playlistBuilder() {
    Column() {
      Text('播放列表')
        .fontSize(22)
        .fontColor($r('app.color.black'))
        .margin({
          left: $r('app.float.player_padding'),
          right: $r('app.float.player_padding'),
          top: $r('app.float.player_padding')
        })

      List({space: 8}){
        ForEach(this.songList,(song:SongItem,index:number) => {
          ListItem(){
            Column(){
              Row(){
                Row(){
                  Text(song.title)
                    .fontSize(18)
                    .fontColor(this.selectIndex === index ? $r('app.color.playing_color') : $r('app.color.black'))
                    .margin({
                      left: $r('app.float.player_padding'),
                      right: $r('app.float.player_padding'),
                    })

                  Text(song.singer)
                    .fontSize(12)
                    .fontColor(this.selectIndex === index ? $r('app.color.playing_color') : $r('app.color.black'))
                    .opacity(this.selectIndex == index ? 1: $r('app.float.singer_opacity'))
                }

                Row(){
                  if (this.selectIndex === index){
                    Image($r('app.media.ic_playing'))
                      .height($r('app.float.control_icon_height'))
                      .width($r('app.float.control_icon_width'))
                      .margin({
                        right: $r('app.float.control_icon_margin'),
                        left: $r('app.float.control_icon_margin')
                      })
                  }

                  Image($r('app.media.ic_delete'))
                    .height($r('app.float.control_icon_height'))
                    .width($r('app.float.control_icon_width'))
                    .margin({
                      right: $r('app.float.control_icon_margin'),
                      left: $r('app.float.control_icon_margin')
                    })
                    .displayPriority(1)
                    .onClick(() => {
                      this.songList.splice(index, 1);
                    })
                }
              }
              .width('100%')
              .justifyContent(FlexAlign.SpaceBetween)

              Divider()
                .height(1)
                .backgroundColor($r('app.color.divider'))
                .margin({
                  left: $r('app.float.player_padding'),
                  right: $r('app.float.player_padding'),
                })
                .opacity($r('app.float.divider_opacity'))

            }
            .width('100%')
            .onClick(() => {
              this.selectIndex = index;
              MediaService.getInstance().loadAssent(this.selectIndex)
            })
          }
        })
      }
      .scrollBar(BarState.Off)
      .backgroundColor(Color.White)
      .width('100%')
      .height('100%')
      .margin({
        top: 20
      })
    }
  }

}