import FluentSQLite
import Vapor
import Leaf

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    /// Register providers first
    try services.register(FluentSQLiteProvider())
    try services.register(LeafProvider())
    config.prefer(LeafRenderer.self, for: ViewRenderer.self)
    
    
    /// Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    /// Register middleware
    var middlewares = MiddlewareConfig.default()// Create _empty_ middleware config
    
    /// middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    middlewares.use(SessionsMiddleware.self)
    services.register(middlewares)
    config.prefer(MemoryKeyedCache.self, for: KeyedCache.self)

    //directoryConfig
    let directoryConfig = DirectoryConfig.detect()
    services.register(directoryConfig)
    
    // Configure a SQLite database
    let sqlite = try SQLiteDatabase(storage: .file(path: "\(directoryConfig.workDir)forums.db"))

    /// Register the configured SQLite database to the database config.
    var databases = DatabasesConfig()
    databases.add(database: sqlite, as: .sqlite)
    services.register(databases)

    /// Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: Forum.self, database: .sqlite)
    migrations.add(model: Message.self, database: .sqlite)
    migrations.add(model: User.self, database: .sqlite)
    services.register(migrations)
    
    

}
