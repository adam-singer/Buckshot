
class TextBoxTests extends TestGroupBase {

  registerTests(){
    this.testGroupName = "TextBox Tests";

    testList["Throw on incorrect input type"] = failOnIncorrectInputType;
    testList["Accepts correct input types"] = acceptCorrectInputTypes;
  }

  void failOnIncorrectInputType(){
    TextBox t = new TextBox();

    Expect.throws(
    ()=> t.inputType = null,
    (e) => (e is BuckshotException)
    );
  }

  void acceptCorrectInputTypes(){
    TextBox t = new TextBox();

    //iterate through all the available types
    for(InputTypes s in InputTypes.validInputTypes){
      t.inputType = s;
    }
  }

}
