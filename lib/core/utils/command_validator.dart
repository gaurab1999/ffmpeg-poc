import 'dart:io';

class CommandValidator {
  static void validateCommand(String command) {
    // Implement validation logic, for example:
    if (command.isEmpty) {
      throw Exception("Command cannot be empty");
    }
    // Add more validations as necessary.
  }

  static Future<void> ensureDirectoryExists(String directoryPath) async {
    final directory = Directory(directoryPath);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
  }
}
