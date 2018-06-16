class ApplicationDatabase {
    static final ApplicationDatabase _singleton = new ApplicationDatabase._internal();

    factory ApplicationDatabase() {
      return _singleton;
    }

    ApplicationDatabase._internal();
}