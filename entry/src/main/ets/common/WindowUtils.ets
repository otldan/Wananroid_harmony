import window from '@ohos.window';
import { hilog } from '@kit.PerformanceAnalysisKit';

export default class WindowUtils{

  static statusBarHeight : number = 0;
  static navigationBarHeight: number = 0
  static windowWidth: number = 0
  static windowHeight: number = 0

  static init(windowClass :window.Window){
    const windowRect = windowClass.getWindowProperties().windowRect;
    WindowUtils.windowWidth = windowRect.width;
    WindowUtils.windowHeight = windowRect.height;
    hilog.info(0x0000, 'WindowUtils.windowWidth', '%{public}s', WindowUtils.windowWidth+" === ");
    const statusBarAvoidArea = windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
    WindowUtils.statusBarHeight = statusBarAvoidArea.topRect.height;
    const navigationBarAvoidArea = windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
    WindowUtils.navigationBarHeight = navigationBarAvoidArea.bottomRect.height;
  }
}