import promptAction from '@ohos.promptAction'
import WindowUtils from '../common/WindowUtils';

export function toast(message: string | Resource) {
  if (message) {
    promptAction.showToast({
      message: message,
    })
  }
}
