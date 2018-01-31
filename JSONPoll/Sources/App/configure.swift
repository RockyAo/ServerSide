import Vapor
import Fluent
import FluentSQLite


/// Called before your application initializes.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#configureswift)
public func configure(
    _ config: inout Config,
    _ env: inout Environment,
    _ services: inout Services
) throws {
    // register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    // configure your application here
    let dirConfig = DirectoryConfig.default()
    services.register(dirConfig)
    
    try services.register(FluentProvider())
    try services.register(FluentSQLiteProvider())
    
    var dataBaseConfig = DatabaseConfig()
    
    let db = try SQLiteDatabase(storage: .file(path: "\(dirConfig.workDir)polls.db"))
    dataBaseConfig.add(database: db, as: .sqlite)
    dataBaseConfig.enableLogging(on: .sqlite)
    
    services.register(dataBaseConfig)
    

    var migrationConfig = MigrationConfig()
//
    migrationConfig.add(model: Poll.self, database: .sqlite)
//
    services.register(migrationConfig)
    
}


extension DatabaseIdentifier{
    static var sqlite: DatabaseIdentifier<SQLiteDatabase> {
        return .init("sqlite")
    }
}



