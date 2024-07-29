import { hilog } from '@kit.PerformanceAnalysisKit'

class LogUtils {
  public isShowLog = false
  private domain: number
  private prefix: string
  private format: string = '%{public}s,%{public}s'

  constructor(prefix: string) {
    this.prefix = prefix
    this.domain = 0xFF00
  }

  debug(...args: string[]) {
    if (this.isShowLog == true) {
      hilog.debug(this.domain, this.prefix, this.format, args)
    }
  }

  info(...args: string[]) {
    if (this.isShowLog == true) {
      hilog.info(this.domain, this.prefix, this.format, args)
    }
  }

  warn(...args: string[]) {
    if (this.isShowLog == true) {
      hilog.warn(this.domain, this.prefix, this.format, args)
    }

  }

  error(...args: string[]) {
    if (this.isShowLog == true) {
      hilog.error(this.domain, this.prefix, this.format, args)
    }
  }
}

export let Logger = new LogUtils('ZyOng')

