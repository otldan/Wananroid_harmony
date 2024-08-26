
@Component
export struct AccountPage{

  build() {
    SideBarContainer(SideBarContainerType.Embed){

      Column(){
        Text('侧边栏')
      }
      Column(){
        Text('内容区域')
      }
    }
    .showSideBar(true)
    .sideBarPosition(SideBarPosition.End)

  }
}