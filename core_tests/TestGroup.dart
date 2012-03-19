/**
* A base class for defining groups of tests to be performed */
class TestGroupBase {
  
  final LinkedHashMap<String, Function> testList;
  String testGroupName;
  
  TestGroupBase() : testList = new LinkedHashMap<String, Function>()
  {
    registerTests();
  }
  
  abstract void registerTests();
  
}
