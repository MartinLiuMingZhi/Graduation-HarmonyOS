const EMAIL_PATTERN = "^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\\.[a-zA-Z0-9-.]+$";

export class MailUtil {
  static isValidEmail(email: string): boolean {
    return email.match(EMAIL_PATTERN) !== null;
  }
}