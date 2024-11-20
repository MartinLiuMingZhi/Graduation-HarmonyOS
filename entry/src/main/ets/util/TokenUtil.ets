import { preferences } from '@kit.ArkData'
import AppStorage from './AppStorage'


const PREFERENCES_NAME = 'my_preferences'
const TOKEN_KEY = 'token'

/**
 * TokenUtil 类用于管理用户的 token
 */
export class TokenUtil{

  /**
   * 静态属性，用于存储偏好设置的 Promise
   */
  private static preferencePromise = preferences.getPreferences(AppStorage.getInstance().getContext(), PREFERENCES_NAME)

  /**
   * 设置 token
   * @param token - 要设置的 token 字符串
   */
  static async setToken(token: string) {
    TokenUtil.preferencePromise.then(async (preferences:preferences.Preferences)=>{
      await preferences.put(TOKEN_KEY, token)
      preferences.flush()
    })
  }

  /**
   * 获取 token
   * @returns 当前存储的 token 字符串，如果获取失败则返回 null
   */
  static async getToken() {
    TokenUtil.preferencePromise.then(async (preferences:preferences.Preferences)=>{
      return await preferences.get(TOKEN_KEY,"")
    })
  }

  /**
   * 移除 token
   */
  static async removeToken() {
    TokenUtil.preferencePromise.then(async (preferences:preferences.Preferences)=>{
      await preferences.delete(TOKEN_KEY)
      preferences.flush()
    })
  }
}
