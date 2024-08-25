


export interface  SquareTab{
  tabName:Resource,
  index:number,
  id:number,
  cid:number
}

export function getTabList(){
  let squareTabList :SquareTab[] = [
    {tabName:$r('app.string.popularBlog'),index:0,id:0,cid:0},
    {tabName:$r('app.string.dailyAsk'),index:1,id:1,cid:440},
    {tabName:$r('app.string.interview'),index:2,id:2,cid:73},
    {tabName:$r('app.string.performance'),index:3,id:3,cid:78},
    {tabName:$r('app.string.framework'),index:4,id:4,cid:152},
    {tabName:$r('app.string.openSourceLibrary'),index:5,id:5,cid:460},
    {tabName:$r('app.string.manufacturers'),index:6,id:6,cid:510}
  ]

  return squareTabList
}
