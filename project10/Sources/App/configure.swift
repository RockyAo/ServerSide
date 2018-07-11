
import Vapor
import FluentMySQL
import Leaf

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    /// Register providers first
    try services.register(FluentMySQLProvider())
    
    try services.register(LeafProvider())
    config.prefer(LeafRenderer.self, for: ViewRenderer.self)
    /// Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    /// Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    /// middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    // Configure a SQLite databaseGRANT ALL PRIVILEGES ON swift.* to swift@localhost IDENTIFIED BY 'swift';
    let mySQLConfig = MySQLDatabaseConfig(hostname: "localhost", port: 3306, username: "root", password: "root", database: "project10")
    let mysql = MySQLDatabase(config: mySQLConfig)
    /// Register the configured SQLite database to the database config.
    var databases = DatabasesConfig()
    databases.add(database: mysql, as: .mysql)
    services.register(databases)

    /// Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: Category.self, database: .mysql)
    migrations.add(model: Post.self, database: .mysql)
    services.register(migrations)
    
    var tags = LeafTagConfig.default()
    tags.use(LinkTag(), as: "link")
    tags.use(MarkdownTag(), as: "markdown")
    services.register(tags)
}
