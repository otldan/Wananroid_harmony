import EntryContext from '../common/EntryContext'

export class StringUtils{
  static  getString(content:Resource):string{
    let context:Context = EntryContext.getContext() as Context
    return context.resourceManager.getStringSync(content)

  }
}