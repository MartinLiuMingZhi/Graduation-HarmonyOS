import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { PreferencesUtil } from '../utils/PreferencesUtil';
import { requestPermissions } from '../service/PermissionService';
import { MediaService } from '../service/MediaService';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');

    // const appStorage = AppStorage.getInstance()
    // appStorage.setContext(this.context)

    // Initialize PreferencesUtil
    PreferencesUtil.init(this.context).then(() => {
      hilog.info(0x0000, 'testTag', '%{public}s', 'PreferencesUtil initialized');
    }).catch((error:Error) => {
      hilog.error(0x0000, 'testTag', 'Failed to initialize PreferencesUtil: %{public}s', JSON.stringify(error));
    });

    try {
       const mediaService = MediaService.getInstance();
    }catch (e) {
      hilog.error(0x0000, 'testTag', 'Failed to initialize MediaService: %{public}s', JSON.stringify(e));
    }
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/MyAPP', (err) => {
      requestPermissions(this.context)
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
