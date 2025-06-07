// 文件路径: /entry/src/main/ets/utils/PasswordStrengthUtil.ets
import { PasswordRule } from "../data/PasswordRule";

export class PasswordStrengthUtil {
  // 定义密码规则接口
  static readonly PasswordRule:PasswordRule = {
    strong: /^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{8,}$/,  // 强密码：至少8位字母、数字和特殊字符
    medium: /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$/,  // 中等密码：至少6位字母和数字
  };

  /**
   * 检测密码强度
   * @param password 输入的密码字符串
   * @returns '强' | '中' | '弱'
   */
  public static checkPasswordStrength(password: string): '强' | '中' | '弱' {
    if (PasswordStrengthUtil.PasswordRule.strong.test(password)) {
      return '强';
    } else if (PasswordStrengthUtil.PasswordRule.medium.test(password)) {
      return '中';
    } else {
      return '弱';
    }
  }

  /**
   * 获取密码强度值（用于进度条展示）
   * @param strength 密码强度等级（'强'/'中'/'弱'）
   * @returns 对应的数值百分比
   */
  public static getPasswordStrengthValue(strength: '强' | '中' | '弱'): number {
    switch (strength) {
      case '强':
        return 100;
      case '中':
        return 60;
      default:
        return 30;
    }
  }
}
