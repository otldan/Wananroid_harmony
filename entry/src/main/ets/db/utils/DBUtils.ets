import { relationalStore } from '@kit.ArkData'
import { BusinessError } from '@ohos.base';
import { Logger } from '../../utils/LogUtils';
import { CommonConstants } from '../common/CommonConstans';

let context = getContext(this);
const STORE_CONFIG: relationalStore.StoreConfig = {
  name: "Wan_Android.db",
  securityLevel: relationalStore.SecurityLevel.S1
};
let store: relationalStore.RdbStore | undefined = undefined;
const COLUMN_TYPE_MAP = [
  ['username', 'varchar(30)'],
];

const valueBucket1: relationalStore.ValuesBucket = {
  'username': '张勇',
};

export class DBUtils {
  public  creteDB() {
    // let context: Context = getContext(this) as Context;
    relationalStore.getRdbStore(context, STORE_CONFIG, (err: BusinessError, rdbStore: relationalStore.RdbStore) => {
      store = rdbStore
      Logger.info("DBUtils",'create table done.'+store);
      if (store != undefined) {
        (store as relationalStore.RdbStore).executeSql(CommonConstants.SQL_CREATE_USER_TABLE, (err) => {
          if (err) {
            Logger.error(`ExecuteSql failed, code is ${err.code},message is ${err.message}`);
            return;
          }
          this.insertData();
        })
      }
    })
  }

  public  insertData() {
    if (store != undefined) {
      (store as relationalStore.RdbStore).insert(CommonConstants.SQL_TABLE_NAME, valueBucket1,
        (err: BusinessError, rowId: number) => {
          if (err) {
            Logger.error(`Insert is failed, code is ${err.code},message is ${err.message}`);
            return;
          }
          Logger.info("DBUtils",`Insert is successful, rowId = ${rowId}`);
        })
    }
    Logger.info("DBUtils",`Insert is successful, `);
  }

  public  async queryData(): Promise<User> {
    let res: User = new User();
    if (store != undefined) {
      (store as relationalStore.RdbStore).querySql(CommonConstants.SQL_QUERY_USER_TABLE, (err, resultSet) => {
        if (err) {
          Logger.error(`Query failed, code is ${err.code},message is ${err.message}`);
          return;
        }
        Logger.info("DBUtils",`ResultSet column names: ${resultSet.columnNames}, column count: ${resultSet.columnCount}`);
        while (resultSet.goToNextRow()) {
          let id = resultSet.getString(resultSet.getColumnIndex("id"));
          res.setId(id);
          let name = '';
          try {
            name = resultSet.getString(resultSet.getColumnIndex(COLUMN_TYPE_MAP[0][0]));
            res.setNickName(name);
            Logger.info("DBUtils",' query 结果='+name);
          } catch (error) {
            Logger.error("DBUtils",`ExecuteSql failed, code is ${error.code},message is ${error.message}`);
            resultSet.close();
            return res;
          }
          resultSet.close();
          return res;
        }
        resultSet.close();
        return res;
      })
    }
    Logger.info("DBUtils",'Empty query');
    return res;
  }
}

export class User {
  id: string = '-1'
  username: string = ''

  public setId(id: string): void {
    this.id = id;
  }


  public setNickName(nickname: string): void {
    this.username = nickname
  }
}