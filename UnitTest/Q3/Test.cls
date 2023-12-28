Class UnitTest.Q3.Test Extends %UnitTest.TestCase
{

Method TestQ3()
{
    // replace contents
    
    set unitTestSc = $$$OK
    set studentClass = ##class(%Dictionary.ClassDefinition).%OpenId("Bank.Account",,.sc)

    do $$$AssertStatusOK(sc, "Checking if Bank.Account class exists")

    //Get an object containing all of the class's methods
    set studentMethods = studentClass.Methods

    //Loop over the methods and get the index of the CountEmptyAccounts
    set methodFound = 0
    for i=1:1:studentMethods.Count() {
        if studentMethods.GetAt(i).Name = "CountEmptyAccounts" {
            set methodFound = 1
            set correctSpec = 0
            set spec = studentMethods.GetAt(i).FormalSpec
            if (spec = "") set correctSpec = 1
            set correctReturn = 0
            if studentMethods.GetAt(i).ReturnType = "%Integer" set correctReturn = 1
            set isClassMethod = studentMethods.GetAt(i).ClassMethod
            }
    }

    do $$$AssertTrue(methodFound, "Checking if the CountEmptyAccounts method is found")
    do $$$AssertTrue(isClassMethod, "Checking if the CountEmptyAccounts function is a method a ClassMethod")
    do $$$AssertTrue(correctSpec, "Checking if the CountEmptyAccounts method has the correct arguments")
    do $$$AssertTrue(correctReturn, "Checking if the CountEmptyAccounts method has the correct return type")

    // delete all instances of Bank.Account
    do ##class(Bank.Account).%DeleteExtent()
    
    // Create 5 accounts, 3 have balance of zero or less than zero and 2 have positive blanace
    For i = 1:1:5 {
        set account = ##class(Bank.Account).%New()
        set account.Balance = i - 3
        set sc = account.%Save()
    }

    //Check that when running the student method it shows the right values
    set sc = $$$AssertEquals(##class(Bank.Account).CountEmptyAccounts(),3,"Checks if class method can detect empty accounts")
    Return unitTestSc
}

}