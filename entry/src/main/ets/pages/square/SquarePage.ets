import { getTabList, SquareTab } from '../../model/SquareBean'
import { StringUtils } from '../../utils/StringUtils'
import { TitleView } from '../../widgets/TitleView'
import { SquareListPage } from './SquareListPage'

//广场 --- 热门 、问答、面试、性能、framework、开源、大厂分享
@Component
export struct SquarePage {
  squareList: SquareTab[] = getTabList()
  controller: TabsController = new TabsController();
  @State currentIndex: number = 0
  @State chageIndex: number = 0

  build() {
    Column() {
      TitleView({
        showBack: false,
        title: StringUtils.getString($r('app.string.square'))
      })
      Tabs({ controller: this.controller }) {
        ForEach(this.squareList, (item: SquareTab,index:number) => {
          TabContent(){
            SquareListPage({cid:item.cid})
          }.tabBar(this.TabBuilder(item.tabName,index))

        })
      }
      .vertical(false)
      .barMode(BarMode.Scrollable,{
        margin:$r('app.float.size_18')
      })
      .barPosition(BarPosition.Start)
      .scrollable(true)
      .barWidth('100%')
      .barHeight($r('app.float.size_36'))
      .onChange((index:number) =>{
        this.currentIndex = index;
      })
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  TabBuilder(res: Resource,index:number) {
    Text(res).padding({
      right:$r('app.float.size_30')
    }).fontColor(this.currentIndex == index ? $r('app.color.main') : $r('app.color.text_h1'))
      .textAlign(TextAlign.Center)
  }
}