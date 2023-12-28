Class MySample.Dispatch Extends %CSP.REST
{

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<Route Url="/index.html" Method="GET" Call="ReturnFrontEnd"/>
<Route Url="/style.css" Method="GET" Call="ReturnStyle"/>
<Route Url="/script.js" Method="GET" Call="ReturnScript"/>
<Route Url="/:testnum" Method="GET" Call="StartUnitTest"/>
</Routes>
}

/// Starts a unit test based on the URL parameter
ClassMethod StartUnitTest(testNum As %String) As %Status
{
    Set sc = $$$OK
    kill ^UnitTest.Result
    
    //To do: sanitize input
    Do ##class(%UnitTest.Manager).RunTest(testNum, "/nodelete")
    Set $LISTBUILD(UnitTestResult) = ^UnitTest.Result(1,testNum)

    // one conditional for each question

    // Replace "Secret" with secret answer word for Q1. Keep XYZ.
    if UnitTestResult && (testNum = "Q1") {
        write !,"XYZSecretXYZ"
        Return sc
    }
    // Replace "Secret" with secret answer word for Q2. Keep XYZ.
    elseif UnitTestResult && (testNum = "Q2") {
        write !,"XYZSecretXYZ"
        Return sc
    }
    // Replace "Secret" with secret answer word for Q1. Keep XYZ.
    elseif UnitTestResult && (testNum = "Q3"){
        write !,"XYZSecretXYZ"
        Return sc
    } else {
        write !,"%Error test failed or improper testNum"
        Return sc
    }
}

ClassMethod ReturnFrontEnd() As %Status
{
    Set stream=##class(%Stream.FileCharacter).%New()
    Set sc=stream.LinkToFile(^FrontEndBasePath_"index.html")
    if $$$ISERR(sc) {
        write "Unable to link to file"
        return $$$OK
    }
    While 'stream.AtEnd {
    	Set line=stream.Read()
    	Write line
    }
	return $$$OK
}

ClassMethod ReturnStyle() As %Status
{
    set %response.ContentType = "text/css"
    Set stream=##class(%Stream.FileCharacter).%New()
    Set sc=stream.LinkToFile(^FrontEndBasePath_"style.css")
    if $$$ISERR(sc) {
        write "Unable to link to file"
        return $$$OK
    }
    While 'stream.AtEnd {
    	Set line=stream.Read()
    	Write line
    }
	return $$$OK
}

ClassMethod ReturnScript() As %Status
{
    set %response.ContentType = "text/javascript"
    Set stream=##class(%Stream.FileCharacter).%New()
    Set sc=stream.LinkToFile(^FrontEndBasePath_"script.js")
    if $$$ISERR(sc) {
        write "Unable to link to file"
        return $$$OK
    }
    While 'stream.AtEnd {
    	Set line=stream.Read()
    	Write line
    }
	return $$$OK
}

}
