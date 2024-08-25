import WindowUtils from '../common/WindowUtils'
import { ArticleItemBean } from '../model/ArtcleItemBean'
import { common, Context } from '@kit.AbilityKit'
import EntryContext from '../common/EntryContext'
import { hilog } from '@kit.PerformanceAnalysisKit'
import { RouterUtils } from '../utils/RouterUtils'

@Component
export struct ArticleItem {
  @Prop
  articleBean:ArticleItemBean

  build() {
    RelativeContainer() {

      Image($r('app.media.collect_default_select'))
        .objectFit(ImageFit.Contain)
        .width($r('app.float.size_60'))
        .height($r('app.float.size_120'))
        .padding({
          top: $r('app.float.size_44'),
          bottom: $r('app.float.size_44'),
          left: $r('app.float.size_14'),
          right: $r('app.float.size_14'),
        })
        .alignRules({
          top: { anchor: '__container__', align: VerticalAlign.Top },
          left: { anchor: "__container__", align: HorizontalAlign.Start },
          bottom: { anchor: '__container__', align: VerticalAlign.Bottom }
        })
        .id('collect')

      if (this.articleBean){
        Row() {
          Text(this.articleBean.title)
            .maxLines(1)
            .ellipsisMode(EllipsisMode.END)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .fontColor($r('app.color.text_h1'))
            .fontSize($r('app.float.float_16'))

        }
        .alignRules({
          top: { anchor: '__container__', align: VerticalAlign.Top },
          left: { anchor: "collect", align: HorizontalAlign.End },
          // right:{anchor:'__container__',align:HorizontalAlign.End}

        }).width('100%')
        .margin({
          top:$r('app.float.size_14')
        })

        Row(){
          Text( getString($r('app.string.shareUser')) + `${this.articleBean.shareUser}` )
            .maxLines(1)
            .ellipsisMode(EllipsisMode.END)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .fontColor($r('app.color.text_h2'))
            .fontSize($r('app.float.float_14'))
          Text(getString($r('app.string.sort'))+this.articleBean.superChapterName+"/"+this.articleBean.chapterName)
            .maxLines(1)
            .ellipsisMode(EllipsisMode.END)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .fontColor($r('app.color.text_h2'))
            .fontSize($r('app.float.float_14'))
            .textAlign(TextAlign.Start)
            .margin({
              left:$r('app.float.size_14')
            })
        }.alignRules({
            bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
            left: { anchor: "collect", align: HorizontalAlign.End },
          }).width("100%").margin({
          bottom:$r('app.float.size_14')
        })
      }

    }
    .width('100%')
    .height($r('app.float.size_76'))
    .padding({
      right :$r('app.float.size_55'),
    }).onClick(()=>{
      RouterUtils.jumpWebPage(this.articleBean.link,this.articleBean.title)
    })

  }




}



function getString(content:Resource):string{
  let context:Context = EntryContext.getContext() as Context
  return context.resourceManager.getStringSync(content)

}
