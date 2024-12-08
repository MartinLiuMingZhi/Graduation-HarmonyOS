import { display } from '@kit.ArkUI';
import { image } from '@kit.ImageKit';
import { effectKit } from '@kit.ArkGraphics2D';
import { common } from '@kit.AbilityKit';
import { BusinessError, Callback } from '@kit.BasicServicesKit';
import { Logger } from '../utils/Logger';
import { TopAreaComponent } from './TopAreaComponent';
import { MusicInfoComponent } from './MusicInfoComponent';
import { LyricsComponent } from './LyricsComponent';
import { ColorConversion } from '../utils/ColorConversion';
import { SongItem } from '../data/SongData';


@Preview
@Component
export struct MusicControlComponent {
  @StorageProp('selectIndex') @Watch('getImageColor') selectIndex: number = 0;
  @StorageLink('songList') songList: SongItem[] = [];
  @StorageLink('imageColor') imageColor: string = 'rgba(0, 0, 2, 1.00)';
  @StorageLink('topArea') topArea: number = 0;
  @StorageLink('bottomArea') bottomArea: number = 0;
  @State imageLabel: PixelMap | Resource = this.songList[this.selectIndex].label;
  @State isShowControl: boolean = true;
  @State isShowControlLg: boolean = false;
  @State isTablet: boolean = true;
  @State isTabletFalse: boolean = false;
  @StorageLink('pageShowTime') pageShowTime: number = 0;
  @State intervalID: number = 0;
  @Link isShowPlay: boolean;
  @StorageLink('isFoldFull') isFoldFull: boolean = false;
  private context: common.UIAbilityContext | undefined = AppStorage.get('context');
  private callback: Callback<display.FoldDisplayMode> = (data: display.FoldDisplayMode) => {
    if (canIUse('SystemCapability.Window.SessionManager')) {
      if (data === display.FoldDisplayMode.FOLD_DISPLAY_MODE_FULL) {
        this.isFoldFull = true;
      } else {
        this.isFoldFull = false;
      }
    }
  };

  aboutToAppear(): void {
    // this.getImageColor();
    try {
      if (canIUse('SystemCapability.Window.SessionManager')) {
        let mode = display.getFoldDisplayMode();
        if (mode === display.FoldDisplayMode.FOLD_DISPLAY_MODE_FULL) {
          this.isFoldFull = true;
        }
        display.on('foldDisplayModeChange', this.callback);
      }
    } catch (exception) {
      Logger.error('Failed to register callback. Code: ' + JSON.stringify(exception));
    }
  }

  aboutToDisappear(): void {
    if (canIUse('SystemCapability.Window.SessionManager')) {
      display.off('foldDisplayModeChange', this.callback);
    }
  }

  build() {
    Stack() {
      Image($r('app.media.song_img'))
        .size({
          height: '120%'
        })
        .aspectRatio(1)
        .objectFit(ImageFit.Cover)
        .opacity(0.5)

      Stack({ alignContent: Alignment.TopStart }) {
        Swiper() {
          MusicInfoComponent()
            .margin({
              top: $r('app.float.music_component_top'),
              bottom: $r('app.float.music_component_bottom')
            })
            .padding({
              left: $r('app.float.common_padding'),
              right: $r('app.float.common_padding')
            })
          LyricsComponent()
            .margin({
              top: $r('app.float.margin_lyric')
            })
            .padding({
              left: $r('app.float.common_padding'),
              right: $r('app.float.common_padding')
            })
        }
        .height('100%')
        .indicator(
          new DotIndicator()
            .top($r('app.float.options_padding'))
            .selectedColor($r('app.color.select_swiper'))
            .color($r('app.color.slider_track'))
        )
        .clip(false)
        .loop(false)
        .onChange((index: number) => {
          if (index === 1) {
            this.isShowControl = true;
            this.intervalID = setInterval(() => {
              this.pageShowTime += 1;
              if (this.pageShowTime > 5) {
                this.isShowControl = false;
                clearInterval(this.intervalID);
              }
            }, 1000);
          } else {
            this.pageShowTime = 0;
            clearInterval(this.intervalID);
          }
        })

        TopAreaComponent({ isShowPlay: this.isShowPlay })
          .padding({
            left: $r('app.float.common_padding'),
            right: $r('app.float.common_padding')
          })
      }
      .height('100%')
    }
    .height('100%')
    .width('100%')
    .backgroundColor(this.imageColor)
  }


  /**
   * Get largest proportion color of an image.
   */
  getImageColor() {
    if (!this.context) {
      return ;
    }
    this.context.resourceManager.getMediaContent(this.songList[this.selectIndex].label)
      .then((value: Uint8Array) => {
        let buffer = value.buffer as ArrayBuffer;
        image.createImageSource(buffer).createPixelMap().then((pixelMap) => {
          effectKit.createColorPicker(pixelMap, (error, colorPicker) => {
            if (error) {
              Logger.error('Failed to create color picker.');
            } else {
              let color = colorPicker.getLargestProportionColor();
              let colorArr = ColorConversion.dealColor(color.red, color.green, color.blue);
              this.imageColor = `rgba(${colorArr[0]}, ${colorArr[1]}, ${colorArr[2]}, 1)`;
            }
          })
          let headFilter = effectKit.createEffect(pixelMap);
          if (headFilter !== null) {
            headFilter.blur(15);
            headFilter.getEffectPixelMap().then((value) => {
              this.imageLabel = value;
            })
          }
        })
          .catch((error: BusinessError) => {
            Logger.error(`${error.code} + ${error.message}`)
          })
      })
      .catch((error: BusinessError) => {
        Logger.error(`${error.code} + ${error.message}`)
      })
  }
}