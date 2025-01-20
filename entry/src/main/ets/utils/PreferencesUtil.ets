import dataPreferences from '@ohos.data.preferences'
import { common } from '@kit.AbilityKit'
import { BusinessError } from '@kit.BasicServicesKit'
import { Logger } from './Logger'

const TAG = "PreferencesUtil"
const PREFERENCES_NAME = 'graduation_preferences'
const FORM_ID = 'formIds';
type ValueType = number | string | boolean | Array<number> | Array<string> | Array<boolean> | Uint8Array | object | bigint

export class PreferencesUtil {
  private static instance: PreferencesUtil
  private static preferences: dataPreferences.Preferences
  private static preferencesAsync: Promise<dataPreferences.Preferences>
  private static initialized: boolean = false;

  public static getInstance(): PreferencesUtil {
    if (!PreferencesUtil.instance) {
      PreferencesUtil.instance = new PreferencesUtil()
    }
    return PreferencesUtil.instance
  }

  public static async init(context: common.UIAbilityContext, name: string = PREFERENCES_NAME): Promise<void> {
    if (PreferencesUtil.preferences) return
    PreferencesUtil.preferences = dataPreferences.getPreferencesSync(context, { name })
    PreferencesUtil.preferencesAsync = dataPreferences.getPreferences(context, name)
    PreferencesUtil.initialized = true
  }

  private static async getPreferencesAsync(): Promise<dataPreferences.Preferences> {
    if (!PreferencesUtil.preferencesAsync) {
      throw new Error('调用init()方法完成初始化')
    }
    return PreferencesUtil.preferencesAsync
  }

  private static getPreferences(): dataPreferences.Preferences {
    if (!PreferencesUtil.preferences) {
      throw new Error('调用init()方法完成初始化')
    }
    return PreferencesUtil.preferences
  }

  static async getAsync<T extends ValueType>(key: string, def?: ValueType): Promise<T> {
    const p = await PreferencesUtil.getPreferencesAsync()
    return new Promise<T>((resolve, reject) => {
      p.get(key, def, (err: BusinessError, data: dataPreferences.ValueType) => {
        if (err) {
          console.error(TAG, err)
          reject(def)
        } else {
          resolve(data as T)
        }
      })
    })
  }

  static async getAllAsync(): Promise<Object> {
    const preferences = await PreferencesUtil.getPreferencesAsync()
    return preferences.getAll()
  }

  static async putAsync(key: string, value: ValueType): Promise<void> {
    const p = await PreferencesUtil.getPreferencesAsync()
    try {
      await p.put(key, value)
      await p.flush()
    } catch (err) {
      console.error(TAG, err)
    }
  }

  static async hasKeyAsync(key: string): Promise<boolean> {
    const p = await PreferencesUtil.getPreferencesAsync()
    return new Promise<boolean>((resolve, reject) => {
      p.has(key, (err: BusinessError, has: boolean) => {
        if (err) {
          console.error(TAG, err)
          reject(err)
        } else {
          resolve(has)
        }
      })
    })
  }

  static async deleteAsync(key: string): Promise<void> {
    const p = await PreferencesUtil.getPreferencesAsync()
    try {
      await p.delete(key)
      await p.flush()
    } catch (err) {
      Logger.error(TAG, err)
    }
  }

  static async clearAsync(): Promise<void> {
    const p = await PreferencesUtil.getPreferencesAsync()
    try {
      await p.clear()
      await p.flush()
    } catch (err) {
      Logger.error(TAG, err)
    }
  }

  static removePreferencesFromCache(context: common.UIAbilityContext): void {
    // Remove cached preferences if needed
    // This method can be customized based on your requirements
  }

  static async getFormIds(context: common.UIAbilityContext): Promise<string[]> {
    const formIds = await PreferencesUtil.getAsync<string[]>('formIds', []);
    return formIds;
  }

  static async addFormId(context: common.UIAbilityContext, formId: string): Promise<void> {
    try {
      const formIds = await PreferencesUtil.getAsync<string[]>('formIds', []);
      if (!formIds.includes(formId)) {
        formIds.push(formId);
        await PreferencesUtil.putAsync('formIds', formIds);
      }
    } catch (error) {
      Logger.error(TAG, `Failed to add formId. Code: ${(error as BusinessError).code}, message: ${(error as BusinessError).message}`);
    }
  }

  static async removeFormId(context: common.UIAbilityContext, formId: string): Promise<void> {
    try {
      const formIds = await PreferencesUtil.getAsync<string[]>('formIds', []);
      const updatedFormIds = formIds.filter(id => id !== formId);
      await PreferencesUtil.putAsync('formIds', updatedFormIds);
    } catch (error) {
      Logger.error(TAG, `Failed to remove formId. Code: ${(error as BusinessError).code}, message: ${(error as BusinessError).message}`);
    }
  }
}
