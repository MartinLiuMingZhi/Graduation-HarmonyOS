import { upload } from '../apis/file';
import { createPost } from '../apis/post';
import { promptAction } from '@kit.ArkUI';
import { FormData } from '@ohos/axios';
import { fileIo as fs } from '@kit.CoreFileKit';
import { photoAccessHelper } from '@kit.MediaLibraryKit';

@Builder
export function PostEditorPageBuilder() {
  PostEditorPage()
}

@Preview
@Component
struct PostEditorPage {
  @State title: string = ''
  @State content: string = ''
  @State selectedImages: string[] = []
  @StorageLink('pathStack') pathStack: NavPathStack = new NavPathStack();
  @State isPosting: boolean = false; // 新增发布状态

  build() {
    NavDestination() {
      Column() {
        // 修改后的图片选择区域
        Scroll() {
          Grid() {
            // 已选图片项
            ForEach(this.selectedImages, (img: string, index: number) => {
              GridItem() {
                Image(img)
                  .width('100%')
                  .aspectRatio(1)
                  .borderRadius(8)
                  .backgroundColor(Color.White)
              }
              .padding(4)
            })

            // 添加按钮
            if (this.selectedImages.length < 9) {
              GridItem() {
                Image($r('app.media.ic_add_photo'))
                  .width('100%')
                  .aspectRatio(1)
                  .backgroundColor('#F5F5F5')
                  .padding(20)
                  .onClick(() => {
                    // 配置选择选项
                    const photoSelectOptions = new photoAccessHelper.PhotoSelectOptions();
                    photoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE;
                    photoSelectOptions.maxSelectNumber = 9 - this.selectedImages.length; // 计算可添加数量

                    // 创建选择器实例
                    const photoPicker = new photoAccessHelper.PhotoViewPicker();

                    // 调用选择方法
                    photoPicker.select(photoSelectOptions)
                      .then(photoSelectResult => {
                        // 将选择的图片 URI 添加到数组
                        this.selectedImages = [...this.selectedImages, ...photoSelectResult.photoUris];
                      })
                      .catch((error: Error) => {
                        console.error('图片选择失败:', error);
                      });
                  })
              }
              .width('100%')
              .aspectRatio(1)
              .borderRadius(8)
              .backgroundColor(Color.White)
              .padding(4)
            }
          }
          .columnsTemplate('1fr 1fr 1fr') // 三列等宽
          .columnsGap(8)
          .rowsGap(8)
          .padding(12)
          .width('100%')
        }
        .scrollable(ScrollDirection.Vertical)
        .scrollBar(BarState.Off)
        .height('40%')

        // 标题输入
        TextInput({ text: this.title, placeholder: '请输入标题...' })
          .maxLength(20)
          .maxLines(1)
          .height(48)
          .width('90%')
          .margin({ top: 8 })
          .onChange((value: string) => {
            this.title = value;
          })

        // 内容输入
        TextArea({ text: this.content, placeholder: '分享你的想法...' })
          .height(200)
          .width('90%')
          .margin(12)
          .onChange((value: string) => {
            this.content = value;
          })

        Blank()

        Row({ space: 10 }) {
          Image($r('app.media.ic_draft'))
            .width(36)
            .height(36)
            .margin({
              left: 8,
            })

          Image($r('app.media.ic_preview'))
            .width(36)
            .height(36)
            .margin({
              left: 8,
            })
            .onClick(() => {
              console.log('点击了预览按钮');
            })

          Button('发布图文')
            .width('70%')
            .height(36)
            .backgroundColor(Color.Red)
            .fontColor(Color.White)
            .enabled(!this.isPosting) // 禁用按钮防止重复提交
            .onClick(() => this.handlePost())

        }
      }
      .width('100%')
      .height('100%')
    }
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

    const uploadPromises = this.selectedImages.map(async (imageUri) => {
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
      this.pathStack.pop(); // 返回上一页
    } catch (error) {
      console.error('发布流程失败:', error);
      // 这里可以添加UI提示，如Toast
    } finally {
      this.isPosting = false;
    }
  }


}