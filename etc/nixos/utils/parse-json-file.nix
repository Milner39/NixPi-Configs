# Take a json file path and return the parsed contents
jsonFilePath:
builtins.fromJSON (builtins.readFile jsonFilePath)