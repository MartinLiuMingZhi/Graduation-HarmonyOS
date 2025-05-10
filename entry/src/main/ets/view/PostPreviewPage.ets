import { createPost, LoginResponse, upload } from "../apis/api";
import { PreferencesUtil } from "../utils/PreferencesUtil";
import { promptAction } from "@kit.ArkUI";
import { FormData } from "@ohos/axios";
import { fileIo as fs } from '@kit.CoreFileKit';

@Builder
export function PostPreviewPageBuilder() {
  PostPreviewPage()
}
@Preview
@Component
export struct PostPreviewPage {
  @State title: string = '春风不知处';
  @State content: string = '林峰不上学\n';
  @State images: string[] = ['http://graduation.liumingzhi.cn/7b14b356-53bc-40da-87c8-9e725663343c.jpg',
    'http://graduation.liumingzhi.cn/8c31ea49-d618-4437-8e4f-1e9c91855487.jpg']
  @State user:  LoginResponse = {
    userid: '',
    username: '',
    email: '',
    avatar: '',
    sex: '',
    token: ''
  };
  @State isPosting: boolean = false; // 新增发布状态
  @StorageLink('pathStack') pathStack: NavPathStack = new NavPathStack();

  aboutToAppear(): void {
    this.loadUserInfo();
    this.initData();
  }

  //获取this.pathStack.pushPathByName('PostPreviewPage',[this.title,this.content,this.selectedImages])传来的数据
  // 获取传递过来的数据并初始化
  private async initData(): Promise<void> {
    try {
      // 获取传递过来的参数
      const param: [string, string, string[]][] = this.pathStack.getParamByName('PostPreviewPage') as [string, string, string[]][];

      // 获取第一个元素并手动赋值
      const firstParam = param[0];
      const title = firstParam[0];
      const content = firstParam[1];
      const selectedImages = firstParam[2];

      // 将获取的值赋给状态
      this.title = title;
      this.content = content;
      this.images = selectedImages;
      console.log('获取到的数据:', title, content, selectedImages);
    } catch (error) {
      console.error('Failed to init data:', error);
    }
  }




  private async loadUserInfo(): Promise<void> {
    // 加载登录用户数据
    try {
      const userData = await PreferencesUtil.getAsync<string>('userInfo');
      if (userData) {
        this.user = JSON.parse(userData)
      }else{
        console.warn('User info not found in PreferencesUtil');
      }
    } catch (error) {
      console.error('Failed to load user info:', error);
    }
  }

  build() {
    NavDestination() {
      Column() {
        // 可滚动区域
        Scroll() {
          Column() {
            Swiper() {
              ForEach(this.images, (item: string, index) => {
                Image(item)
                  .width('100%')
                  .height('auto')
                  .objectFit(ImageFit.Cover)
              })
            }
            .width('100%')
            .height('100%')
            .loop(false)
            .indicator(
              Indicator.dot()
                .selectedColor(Color.Red)
            )

            // 标题
            Text(this.title)
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .textAlign(TextAlign.Start)
              .alignSelf(ItemAlign.Start) // 强制左对齐
              .margin({ top: 10, left: 10, right: 10 })

            // 内容
            Text(this.content)
              .fontSize(14)
              .textAlign(TextAlign.Start)
              .alignSelf(ItemAlign.Start) // 强制左对齐
              .margin({ top: 10, left: 10, right: 10 })

            Divider()
              .width('100%')
              .margin({ top: 10 })

            // 点赞收藏评论
            Row() {
              Blank().layoutWeight(1)

              SymbolGlyph($r('sys.symbol.heart'))
                .width(20)
                .height(20)

              Text('点赞')
                .fontSize(14)
                .margin({ right: 10 })

              SymbolGlyph($r('sys.symbol.star'))
                .width(20)
                .height(20)

              Text('收藏')
                .fontSize(14)
                .margin({ right: 10 })

              SymbolGlyph($r('sys.symbol.ellipsis_message'))
                .width(20)
                .height(20)

              Text('评论')
                .fontSize(14)
                .margin({ right: 10 })
            }
            .justifyContent(FlexAlign.End)
            .margin({ right: 10, top: 10, bottom: 10 }) // 留出按钮高度
          }
        }
        .scrollBar(BarState.Off)
        .width('100%')
        .layoutWeight(1) // 让 Scroll 填满剩余空间

        // 底部固定按钮
        Row() {
          Button('发布图文')
            .width('90%')
            .height(40)
            .backgroundColor(Color.Red)
            .fontColor(Color.White)
            .borderRadius(20)
            .fontWeight(FontWeight.Bold)
            .enabled(!this.isPosting) // 禁用按钮防止重复提交
            .onClick(() => {
              this.handlePost()
            })
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
        .padding({ bottom: 10 })
        .backgroundColor('#ffffff')
      }
      .width('100%')
      .height('100%')
    }
    .title(this.TitleBuilder())
    .margin({ top: 10 })
  }


  @Builder
  TitleBuilder(){
    Row(){
      Image(this.user.avatar)
        .width(30)
        .height(30)
        .borderRadius(15)
        .margin({left: 10})

      Text(this.user.username)
        .fontSize(16)
        .margin({left: 10})
    }
    .width('100%')
    .margin({top: 10})
  }

  /**
   * 上传图片：将用户选择的图片统一复制到缓存目录，
   * 并构造 沙箱路径 格式 URI 添加到 FormData 中上传。
   */
  private async handleUpload(): Promise<string[]> {
    let formData = new FormData();
    // 从上下文中获取缓存目录路径（例如：'/data/accounts/account_0/appdata/your.package/cache'）
    let cacheDir = getContext(this).cacheDir;
    console.info('缓存目录路径:', cacheDir)

    const uploadPromises = this.images.map(async (imageUri) => {
      try {
        // 提取文件名
        const fileName = imageUri.substring(imageUri.lastIndexOf('/') + 1);

        const imgData = await fs.open(imageUri, fs.OpenMode.READ_ONLY)

        // 构造目标路径：缓存目录 + 文件名
        const destPath = `${cacheDir}/${fileName}`;
        // 使用同步方式拷贝文件到缓存目录
        await fs.copyFile(imgData.fd, destPath);
        // 添加到 formData 中，值为 沙箱路径
        formData.append('files', destPath);

        return destPath;
      } catch (e) {
        console.error('文件处理错误:', e);
        throw new Error('图片处理失败');
      }
    });

    try {
      await Promise.all(uploadPromises);
      const result = await upload<string[]>(formData);
      if (result.code !== '200') {
        throw new Error(result.msg || '上传失败');
      }
      return result.data; // 假设返回结构中包含 data 字段
    } catch (error) {
      console.error('文件上传失败:', error);
      throw new Error('图片上传失败: ' + error.message);
    }
  }


  // 优化后的发布方法
  private async handlePost() {
    if (this.isPosting) return;

    try {
      this.isPosting = true;

      // 基础验证
      if (!this.title.trim() || !this.content.trim()) {
        throw new Error('标题和内容不能为空');
      }

      // 分步处理上传和发布
      const imageUrls = await this.handleUpload();
      const postResult = await createPost<string>({
        title: this.title,
        content: this.content,
        images: imageUrls
      });

      if (postResult.code !== '200') {
        throw new Error(postResult.msg || '发布失败');
      }
      promptAction.showToast({
        message: '发布成功',
      });
      // 成功处理
      console.info('发布成功');
      //返回主界面
      this.pathStack.popToIndex(-1);
    } catch (error) {
      console.error('发布流程失败:', error);
      // 这里可以添加UI提示，如Toast
    } finally {
      this.isPosting = false;
    }
  }
}