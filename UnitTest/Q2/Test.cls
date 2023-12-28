Class UnitTest.Q2.Test Extends %UnitTest.TestCase
{

Method TestQ2()
{
    // replace contents
    
    set unitTestSc = $$$OK
    set studentClass = ##class(%Dictionary.ClassDefinition).%OpenId("Bank.Account",,.sc)

    do $$$AssertStatusOK(sc, "Checking if Bank.Account class exists")

    //set up an array containing the right property name and type
    //set rightAnsArr = [{"Name": "Balance", "Type":"%Decimal"},{"Name": "MemberID", "Type":"%Integer"},{"Name": "Type", "Type":"%String"}]

    //Loop over the student's properties and compare them to the right answer dyn array
    set studentMethods = studentClass.Methods

    //Loop over the methods and get the index of the TransferTo
    set methodFound = 0
    for i=1:1:studentMethods.Count() {
        if studentMethods.GetAt(i).Name = "TransferTo" {
            set methodFound = 1
            set correctSpec = 0
            set spec = studentMethods.GetAt(i).FormalSpec
            set spec = $ZCVT(spec, "U")
            set spec = $TR(spec," ", "")
            if (spec = $ZCVT("receivingID:%String,amount:%Decimal", "U")) set correctSpec = 1
            set correctReturn = 0
            if studentMethods.GetAt(i).ReturnType = "%Status" set correctReturn = 1
            set notClassMethod = studentMethods.GetAt(i).ClassMethod
            }
    }

    do $$$AssertTrue(methodFound, "Checking if the TransferTo method is found")
    do $$$AssertNotTrue(notClassMethod, "Checking if the TransferTo function is a method not a ClassMethod")
    do $$$AssertTrue(correctSpec, "Checking if the TransferTo method has the correct input parameters")
    do $$$AssertTrue(correctReturn, "Checking if the TransferTo method has the correct return type")

    //setup account sender
    set sender = ##class(Bank.Account).%New()
    set sender.Balance = 100
    
    //setup account reciever
    set receiver = ##class(Bank.Account).%New()
    set receiver.Balance = 0
    set sc = receiver.%Save()
    do $$$AssertStatusOK(sc,"Check if an instance of Bank.Account can be saved")

    //use TransferTo method to send money from sender to reciever
    set sc = sender.TransferTo(receiver.%Id(), 50)
    do $$$AssertStatusOK(sc,"Check if TransferTo returns an ok status")

    //Check balance of sender and receiver
    set sc1 = $$$AssertEquals(sender.Balance,50,"Check if remaining sender balance is the correct amount")
    set sc2 = $$$AssertEquals(receiver.Balance,50,"Check if new receiver balance is the correct amount")

    do ##class(Bank.Account).%DeleteId(receiver.%Id())
    
    return unitTestSc
}

}
