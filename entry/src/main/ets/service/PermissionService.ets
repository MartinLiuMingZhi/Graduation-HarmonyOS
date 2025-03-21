import { abilityAccessCtrl, common, Permissions } from '@kit.AbilityKit';

/**
 * 申请相机、读写媒体、以及媒体定位权限
 * @param context 当前 UIAbilityContext
 * @returns 返回 Promise<boolean>，true 表示所有权限均已授权
 */
export async function requestPermissions(context: common.UIAbilityContext): Promise<boolean> {
  const permissions: Array<Permissions> = [
    'ohos.permission.CAMERA',
    'ohos.permission.MICROPHONE',
    'ohos.permission.MEDIA_LOCATION',
    'ohos.permission.READ_MEDIA',
    'ohos.permission.WRITE_MEDIA',
  ];
  const atManager = abilityAccessCtrl.createAtManager();
  try {
    // requestPermissionsFromUser 会根据当前权限状态判断是否弹窗申请
    const data = await atManager.requestPermissionsFromUser(context, permissions);
    const grantStatus: Array<number> = data.authResults;
    for (let status of grantStatus) {
      if (status !== 0) {
        // 若有任何一个权限未授权，则返回 false
        console.error('部分权限未授权');
        return false;
      }
    }
    // 所有权限均已授权
    return true;
  } catch (err) {
    console.error(`权限申请失败。错误码：${err.code}, 消息：${err.message}`);
    return false;
  }
}
