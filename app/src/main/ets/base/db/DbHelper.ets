import { relationalStore } from '@kit.ArkData'
import { XLogger } from '../extensions/XLogger'


const TAG = "[DbHelper]"

/**
 *
 * Author: Seagazer
 * Date: 2025/12/30
 */
export enum ColumnValueType {
    STRING = "TEXT",
    NUMBER = "INTEGER"
}

export class Table<T> {
    name: string = ""
    primaryKey: string = "id"
    columns = new Map<string, ColumnValueType>()
    private rdb?: relationalStore.RdbStore = undefined

    constructor(name: string) {
        this.name = name
    }

    setPrimaryKey(primaryKey: string) {
        this.primaryKey = primaryKey
    }

    addColumn(column: string, type: ColumnValueType) {
        this.columns.set(column, type)
    }

    addColumns(columns: Map<string, ColumnValueType>) {
        this.columns = columns
    }

    onCreate(rdb: relationalStore.RdbStore) {
        this.rdb = rdb
    }

    onDestroy() {
        this.rdb = undefined
    }

    async insert(data: T, conflict: relationalStore.ConflictResolution) {
        if (!this.rdb) {
            XLogger.w(TAG, "insert: The RdbStore is undefined!")
            return -1
        }
        try {
            const value: relationalStore.ValuesBucket = {}
            this.columns.forEach((_, key) => {
                value[key] = Reflect.get(data as object, key)
                // value[key] = data[key]
            })
            XLogger.d(TAG, "insert data= " + JSON.stringify(value))
            const resultCode = await this.rdb.insert(this.name, value, conflict)
            return resultCode
        } catch (err) {
            XLogger.e(TAG, "insert error= " + JSON.stringify(err))
            return -1
        }
    }

    async insertArray(list: Array<T>) {
        if (!this.rdb) {
            XLogger.w(TAG, "insertArray: The RdbStore is undefined!")
            return -1
        }
        try {
            const valueList: Array<relationalStore.ValuesBucket> = []
            list.forEach((data) => {
                const value: relationalStore.ValuesBucket = {}
                this.columns.forEach((_, key) => {
                    value[key] = Reflect.get(data as object, key)
                    // value[key] = data[key]
                })
                XLogger.d(TAG, "insert data= " + JSON.stringify(value))
                valueList.push(value)
            })
            const resultCode = await this.rdb.batchInsert(this.name, valueList)
            return resultCode
        } catch (err) {
            XLogger.e(TAG, "insert error= " + JSON.stringify(err))
            return -1
        }
    }

    async delete(matchKey: string, data: T) {
        if (!this.rdb) {
            XLogger.w(TAG, "delete: The RdbStore is undefined!")
            return -1
        }
        try {
            const predicates = new relationalStore.RdbPredicates(this.name)
            predicates.equalTo(matchKey, Reflect.get(data as object, matchKey))
            XLogger.d(TAG, "delete data= " + JSON.stringify(data))
            const resultCode = await this.rdb.delete(predicates)
            return resultCode
        } catch (err) {
            XLogger.e(TAG, "delete error= " + JSON.stringify(err))
            return -1
        }
    }

    async clear() {
        if (!this.rdb) {
            XLogger.w(TAG, "clear: The RdbStore is undefined!")
            return -1
        }
        try {
            const predicates = new relationalStore.RdbPredicates(this.name)
            const resultCode = await this.rdb.delete(predicates)
            return resultCode
        } catch (err) {
            XLogger.e(TAG, "clear error= " + JSON.stringify(err))
            return -1
        }
    }

    async update(matchKey: string, data: T) {
        if (!this.rdb) {
            XLogger.w(TAG, "update: The RdbStore is undefined!")
            return -1
        }
        try {
            const value: relationalStore.ValuesBucket = {}
            this.columns.forEach((_, key) => {
                value[key] = Reflect.get(data as object, key)
            })
            const predicates = new relationalStore.RdbPredicates(this.name)
            predicates.equalTo(matchKey, Reflect.get(data as object, matchKey))
            XLogger.d(TAG, "update data= " + JSON.stringify(value))
            const resultCode = await this.rdb.update(value, predicates)
            return resultCode
        } catch (err) {
            XLogger.e(TAG, "update error= " + JSON.stringify(err))
            return -1
        }
    }

    public async queryAll() {
        if (!this.rdb) {
            XLogger.w(TAG, "queryAll: The RdbStore is undefined!")
            return new Array<T>()
        }
        try {
            const predicates = new relationalStore.RdbPredicates(this.name)
            const columns: Array<string> = []
            this.columns.forEach((_, key) => {
                columns.push(key)
            })
            const cursor = await this.rdb.query(predicates, columns)
            const result: Array<T> = []
            cursor.goToFirstRow()
            while (!cursor.isEnded) {
                const t = this.readRow(cursor)
                result.push(t)
                cursor.goToNextRow()
            }
            cursor.close()
            XLogger.d(TAG, "query list= " + JSON.stringify(result))
            return result
        } catch (err) {
            XLogger.e(TAG, "query error= " + JSON.stringify(err))
            return new Array<T>()
        }
    }

    private readRow(cursor: relationalStore.ResultSet) {
        const result: relationalStore.ValuesBucket = {}
        for (let key of this.columns.keys()) {
            try {
                const valueType = this.columns.get(key)
                switch (valueType) {
                    case ColumnValueType.STRING:
                        let stringValue = cursor.getString(cursor.getColumnIndex(key))
                        result[key] = stringValue
                        break
                    case ColumnValueType.NUMBER:
                        let intValue = cursor.getLong(cursor.getColumnIndex(key))
                        result[key] = intValue
                        break
                }
            } catch (e) {
                XLogger.e(TAG, "get value from db error= " + JSON.stringify(e))
            }
        }
        return result as T
    }
}

export class DbHelper {
    private db?: relationalStore.RdbStore = undefined
    private static sInstance?: DbHelper = undefined

    private constructor() {
    }

    static getInstance() {
        if (DbHelper.sInstance === undefined) {
            DbHelper.sInstance = new DbHelper()
        }
        return DbHelper.sInstance
    }


    async createDb(context: Context, dbName: string, level: relationalStore.SecurityLevel = relationalStore.SecurityLevel.S2) {
        XLogger.d(TAG, "create db " + dbName)
        if (this.db === undefined) {
            try {
                this.db = await relationalStore.getRdbStore(context,
                    {
                        name: dbName + '.db',
                        securityLevel: level
                    })
                XLogger.d(TAG, "create db <" + dbName + "> success")
            } catch (error) {
                XLogger.d(TAG, "create db <" + dbName + "> error= " + JSON.stringify(error))
            }
        } else {
            XLogger.w(TAG, "The db <" + dbName + "> is already created")
        }
    }

    async createTable<T>(table: Table<T>) {
        XLogger.d(TAG, "create table " + table.name)
        if (this.db === undefined) {
            XLogger.e(TAG, "The db is not created, must call #createDb first")
            return
        }
        try {
            let createKeySql = ""
            let i = 0
            for (let key of table.columns.keys()) {
                const value = table.columns.get(key)
                if (i !== table.columns.size - 1) {
                    if (key === table.primaryKey) {
                        createKeySql += key + " " + value + " PRIMARY KEY, "
                    } else {
                        createKeySql += key + " " + value + ", "
                    }
                } else {
                    if (key === table.primaryKey) {
                        createKeySql += key + " " + value + " PRIMARY KEY"
                    } else {
                        createKeySql += key + " " + value
                    }
                }
                i++
            }
            let createTableSql = ""
            if (table.columns.get(table.primaryKey)) {
                createTableSql = "CREATE TABLE IF NOT EXISTS " + table.name + " ( " + createKeySql + ")"
            } else {
                createTableSql = "CREATE TABLE IF NOT EXISTS " + table.name + " (id INTEGER PRIMARY KEY AUTOINCREMENT, " + createKeySql + ")"
            }
            XLogger.d(TAG, "sql= " + createTableSql)
            await this.db.executeSql(createTableSql)
            XLogger.d(TAG, "create table <" + table.name + "> success")
            table.onCreate(this.db)
        } catch (err) {
            XLogger.e(TAG, "create table <" + table.name + "> error= " + JSON.stringify(err))
        }
    }

    setVersion(version: number) {
        if (this.db === undefined) {
            XLogger.e(TAG, "set version failed!")
            return
        }
        this.db.version = version
    }

    getVersion(): number {
        if (this.db === undefined) {
            return -1
        }
        return this.db.version
    }
}

// libary, album, favourite, playlist