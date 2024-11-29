# Design Patterns Used:
- Proxy : database_functions acts as a proxy to do functions related to accessing the database.
- Singleton: only use 1 instance of the database with FirebaseFirestore.instance code.
- Strategy: code uses strategy pattern when deciding what value to query (tag, date, or description) in database_function