import App
import Service
import Vapor
import Leaf

var config = Config.default()
var env = Environment.detect()
var services = Services.default()

try App.configure(&config, &env, &services)
try services.register(LeafProvider())

let app = try Application(
    config: config,
    environment: env,
    services: services
)

try App.boot(app)

try app.run()
