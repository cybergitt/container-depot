# mongosh --: Launches the MongoDB shell, connecting to the default MongoDB instance.
# "$MONGO_INITDB_DATABASE": Specifies the database to connect to (using the value from the environment variable).
# <<EOF: Indicates the start of a multi-line input block. Everything between <<EOF and EOF is treated as MongoDB shell commands to be executed. 
# db.getSiblingDB('admin'): Switches to the admin database, which is the default administrative database in MongoDB. It allows you to perform administrative tasks like user creation, where the user dev-user will be created.
# db.auth('$MONGO_INITDB_ROOT_USERNAME', '$MONGO_INITDB_ROOT_PASSWORD') (commented out): This line, if executed, would authenticate the user with the given credentials against the "admin" database. It’s necessary if the following operations require authentication.
# The user dev-user is created in the admin database with the specified username and password.
# { role: 'root', db: 'admin' }: Allows full access to the admin database.
# { role: 'readWrite', db: '$MONGO_INITDB_DATABASE' }: Grants read and write permissions specifically for dev_database.

mongosh -- "$MONGO_INITDB_DATABASE" <<EOF
db = db.getSiblingDB('admin')
db.auth('$MONGO_INITDB_ROOT_USERNAME', '$MONGO_INITDB_ROOT_PASSWORD')
db.createUser({
  user: "$MONGODB_ROOT_USER",
  pwd: "$MONGODB_ROOT_PASSWORD",
  roles: [
    { role: 'root', db: 'admin' },
    { role: 'root', db: '$MONGO_INITDB_DATABASE' }
  ]
})

db = db.getSiblingDB('$MONGO_INITDB_DATABASE');
db.createCollection('tests');
db.tests.insertMany([
  { name: 'User 1' },
  { name: 'User 2' }
]);
EOF