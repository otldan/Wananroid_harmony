export class CommonConstants {
  static readonly SQL_TABLE_NAME = 'user_info'
  static readonly SQL_CREATE_USER_TABLE: string = `CREATE TABLE IF NOT EXISTS ${CommonConstants.SQL_TABLE_NAME} (id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT NOT NULL)`;
  static readonly SQL_QUERY_USER_TABLE: string = 'SELECT * FROM user_info  WHERE id = 1';

}