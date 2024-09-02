import { PullToRefresh, PullToRefreshConfigurator } from '@ohos/pulltorefresh'
import { ArticleItemBean } from '../../model/ArtcleItemBean'
import { Pair } from '../../model/Pair'
import { Tree } from '../../model/Tree'
import Api from '../../net/Api'
import { Logger } from '../../utils/LogUtils'
import PreferencesUtils from '../../utils/PreferencesUtils'
import { StringUtils } from '../../utils/StringUtils'
import { LoadState, PageLoading } from '../../widgets/PageLoading'
import { ArticleItem } from '../ArticleItem'

@Component
export struct AccountPage {
  @State
  isShowBar: boolean = false
  @State showLoading: boolean = false;
  @State treeList: Tree[] = [];
  @State loadStateTree: LoadState = LoadState.LOADING;
  @State loadStateArticle: LoadState = LoadState.LOADING;
  @State selectTreeTemp?: Tree = undefined;
  @State selectTrees: Pair<Tree | undefined, Tree | undefined> = { first: undefined, second: undefined };
  private page: number = 1;
  private more: boolean = true;
  @State dataList: ArticleItemBean[] = [];
  private scroller: Scroller = new Scroller();
  private refreshConfig = new PullToRefreshConfigurator();

  aboutToAppear(): void {
    this.refreshConfig.setHasRefresh(false)
    this.getTreeData()
  }

  async getTreeData() {
    Logger.info("加载广场数据")
    this.loadStateTree = LoadState.LOADING

    const res = await Api.get().getTree();
    if (res.isSuccessWithData()) {
      if (res.getDataOrThrow().length > 0) {
        this.treeList = res.getDataOrThrow()
        const selectTreeId = PreferencesUtils.get(getContext()).getHistory()
        const selectParent = this.treeList.find((item) => {
          item.id == selectTreeId.first
        })
        const selectChild = selectParent?.children?.find((item) => {
          item.id == selectTreeId.second
        })
        //获取本地是否保存过

        if (selectParent != undefined && selectChild != undefined) {
          Logger.info("AccountPage", "本地数据 == " + selectChild.name)
          this.selectTreeTemp = selectParent;
          this.selectTrees = { first: selectParent, second: selectChild };
        } else {
          this.selectTreeTemp = this.treeList[0];
          this.selectTrees = { first: this.treeList[0], second: this.treeList[0].children[0] };
        }

        this.loadStateTree = LoadState.SUCCESS;
        this.getArticleListData()
      } else {
        this.loadStateTree = LoadState.EMPTY
      }
    } else {
      this.loadStateTree = LoadState.FAIL
    }

  }

  private getArticleListData() {
    this.loadStateArticle = LoadState.LOADING;
    this.page = 1;
    this.getArticleDataByPage(0).then(
      (data) => {
        this.dataList = data;
        if (this.dataList.length === 0) {
          this.loadStateArticle = LoadState.EMPTY;
        } else {
          this.loadStateArticle = LoadState.SUCCESS;
        }
      },
      () => {
        this.loadStateArticle = LoadState.FAIL;
      })
  }

  private async getArticleDataByPage(page: number): Promise<ArticleItemBean[]> {
    const res = await Api.get().getTreeArticleList(this.selectTrees.second!.id, page);
    Logger.info("加载广场数据" + JSON.stringify(res))
    if (res.isSuccessWithData()) {
      const list = res.getDataOrThrow().datas;
      return Promise.resolve(list);
    } else {
      return Promise.reject();
    }
  }

  build() {
    SideBarContainer(SideBarContainerType.Overlay) {
      Column() { //侧边栏
        Row() {
          Image($r('app.media.fanhui')).width($r('app.float.size_30')).height($r('app.float.size_30'))
            .onClick(() => {
              this.isShowBar = false
            })
          Text($r('app.string.special_column'))
            .fontColor($r('app.color.text_h1'))
            .fontWeight(700)
            .fontSize($r('app.float.float_18'))
            .width('100%')
            .textAlign(TextAlign.Center)
            .height('100%')

        }.height($r('app.float.size_40'))
        .margin({
          top: $r('app.float.size_12'),
          right: $r('app.float.size_40'),
          left: $r('app.float.size_12')
        })


        Scroll() {
          Flex({ wrap: FlexWrap.Wrap }) {
            ForEach(this.treeList, (tree: Tree) => {
              Text(tree.name)
                .fontColor($r('app.color.text_h1'))
                .fontWeight(700)
                .fontSize($r('app.float.float_16'))
                .margin({
                  left: $r('app.float.size_12'),
                  right: $r('app.float.size_12'),
                  top: $r('app.float.size_12'),
                  bottom: $r('app.float.size_12')
                })
                .width('100%')

              ForEach(tree.children, (childTree: Tree) => {
                Text(childTree.name)
                  .fontSize($r('app.float.float_14'))
                  .fontColor(this.selectTrees.second?.id == childTree.id ? $r('app.color.main') :
                  $r('app.color.text_h2'))// .fontColor($r('app.color.text_h2'))
                  .padding({
                    left: $r('app.float.size_6'),
                    right: $r('app.float.size_6'),
                    top: $r('app.float.size_5'),
                    bottom: $r('app.float.size_5')
                  })
                  .margin({
                    left: $r('app.float.size_12'),
                    right: $r('app.float.size_12'),
                    top: $r('app.float.size_6'),
                    bottom: $r('app.float.size_6')
                  })
                  .borderWidth($r('app.float.size_2'))
                  .borderRadius($r('app.float.size_6'))
                  .borderColor(this.selectTrees.second?.id == childTree.id ? $r('app.color.main') :
                  $r('app.color.text_h2'))
                  .onClick(() => {
                    this.selectTrees = { first: tree, second: childTree };
                    this.isShowBar = false
                    this.more = true
                    this.scroller.scrollToIndex(0);
                    this.getArticleListData()

                  });

              })
            })
          }
        }.padding({
          top: $r('app.float.float_20'),
          left: $r('app.float.float_14'),
          right: $r('app.float.float_14'),
          bottom: $r('app.float.float_20')
        })
      }.backgroundColor($r('app.color.divider'))
      .borderRadius({
        topLeft: $r('app.float.float_16'),
        bottomLeft: $r('app.float.float_16'),
      })

      Column() { //内容
        Row() {
          if (this.selectTrees.first != undefined) {
            Text(this.selectTrees.first?.name + ' > ' + this.selectTrees.second?.name)
              .fontSize($r('app.float.float_14'))
              .fontColor($r('app.color.text_h1'))
              .layoutWeight(1)
          } else {
            Blank()
          }
          Image($r('app.media.gengduo')).onClick(() => {

            animateTo({}, () => {
              this.isShowBar = true
            })
          }).width($r('app.float.size_36'))
            .height($r('app.float.size_36'))
        }.width('100%')

        PageLoading({
          loadState: this.loadStateTree,
          showLoading: this.showLoading,
          onReload: () => {
            this.getTreeData()
          },
        }) {
          Column() {
            PullToRefresh({
              data: this.dataList,
              scroller: this.scroller,
              refreshConfigurator: this.refreshConfig,
              customList: () => {
                this.ArticleList();
              },
              onLoadMore: () => {
                return new Promise<string>((resolve) => {
                  Logger.info("是否加载完全部数据" + this.more)
                  if (this.more) {
                    this.getArticleDataByPage(this.page).then(
                      (data) => {
                        if (data.length > 0) {
                          this.page++
                          this.dataList = this.dataList.concat(data);
                          resolve(StringUtils.getString($r('app.string.load_suc')));
                        } else {
                          this.more = false;
                          resolve(StringUtils.getString($r('app.string.load_more')));
                        }
                      },
                      () => {
                        resolve(StringUtils.getString($r('app.string.load_fail')));
                      }
                    )
                  } else {
                    resolve(StringUtils.getString($r('app.string.load_more')));
                  }
                });
              },
              customLoad: null,
              customRefresh: null,
            })
          }
          .width('100%')
          .height('100%')
        }
      }.padding({
        top: $r('app.float.float_20'),
        left: $r('app.float.float_14'),
        right: $r('app.float.float_14'),
        bottom: $r('app.float.float_20')
      })
    }
    .sideBarWidth('70%')
    .showSideBar(this.isShowBar)
    .sideBarPosition(SideBarPosition.End)
    .showControlButton(false)
    .width('100%')
    .height('100%')
    .onChange((status) => {
      this.isShowBar = status
    })

  }

  @Builder
  private ArticleList() {
    List({ scroller: this.scroller }) {
      ForEach(this.dataList, (item: ArticleItemBean) => {
        ListItem() {
          ArticleItem({
            articleBean: item
          })
        }
      })
    }
    .width('100%')
    .height('100%')
    .listDirection(Axis.Vertical)
    .divider({
      strokeWidth: 0.5,
      color: $r("app.color.divider"),
      startMargin: 16,
      endMargin: 16
    })
    .edgeEffect(EdgeEffect.None)

  }
}