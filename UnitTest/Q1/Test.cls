Class UnitTest.Q1.Test Extends %UnitTest.TestCase
{
    
Method TestQ1()
{
    // replace contents
    
    set unitTestSc = $$$OK

    set studentClass = ##class(%Dictionary.ClassDefinition).%OpenId("Bank.Account",,.sc)
    
    do $$$AssertStatusOK(sc, "Checking if Bank.Account class exists")
    do $$$AssertEquals(studentClass.Super, "%Persistent", "Checking if the class inherits from %Persistent")
    
    //set up an array containing the right property name and type
    set rightAnsArr = [{"Name": "Balance", "Type":"%Decimal"},{"Name": "MemberID", "Type":"%Integer"},{"Name": "Type", "Type":"%String"}]
    
    //Loop over the student's properties and compare them to the right answer dyn array
    set studentProperties = studentClass.Properties
    
    //set the loop count to the smaller of student properties or 3 to prevent looping over nonexistent elements
    set loopCount = 3
    do $$$AssertEquals(loopCount, studentProperties.Count(), "Checking if the class has the right number of properties.")
    if studentProperties.Count() < loopCount set loopCount = studentProperties.Count()
    
    //Check if each of the student properties has the right name and type
    for i=1:1:loopCount {
        set property = studentProperties.GetAt(i)
        set rightAnswerName = rightAnsArr.%Get(i-1)."Name"
        do $$$AssertEquals(property.Name, rightAnswerName, "Checking if the property "_rightAnswerName_" exists.")
        set rightAnswerType = rightAnsArr.%Get(i-1)."Type"
        do $$$AssertEquals(property.Type, rightAnswerType, "Checking if the property "_rightAnswerName_" has the right type.")
    }

    return unitTestSc
}

}