const appUrl = "/unittests/rest/"

const app = document.querySelector(`#app`);

app.addEventListener('click', event => {
    if (event.target.className == "unit-test-btn") launchTest(event.target)
})

async function launchTest(btn) {
    changeStatus("running", btn)
    //modify this line or modify the button IDs if the URL for StartUnitTest on the server is different
    let res = await fetch(`${appUrl}${btn.id}`);
    if (res.status != 200) alert("Unable to connect to the IRIS instance");
    let text = await res.text();
    handleFeedback(text, btn)
}

function handleFeedback(text, btn) {
    let textArr = text.split(`\r\n`);
    let testsArr = [];
    for (let line of textArr) {
        line = line.trim()
        if (line.includes("Assert")) testsArr.push(line)
    }
    changeTests(testsArr, btn)
    const lastLine = textArr.at(-1)
    console.log("last line is ", lastLine)
    lastLine.includes("XYZ") ? handleSuccess(btn, lastLine) : handleFailure(btn);
}

function handleSuccess(btn, lastLine) {
    changeStatus("success", btn)
    const scrtWordContainer = btn.nextElementSibling.nextElementSibling.nextElementSibling
    const secretWord = lastLine.slice(3, -3)
    scrtWordContainer.firstElementChild.textContent = secretWord
}

function handleFailure(btn) {
    changeStatus("fail", btn)
}

function changeTests(testsArr, btn) {
    const testsContainer = btn.nextElementSibling.nextElementSibling
    const re = /(.+)(\(passed\)|\(failed\))/
    const table = document.createElement('table');
    for (let test of testsArr) {
        let matchResult = test.match(re)
        let testText = matchResult[1];
        let testResult = matchResult[2];
        const tr = document.createElement('tr');
        const td1 = document.createElement('td');
        td1.textContent = testText
        const td2 = document.createElement('td');
        td2.textContent = testResult
        testResult.includes("passed") ? td2.className = "success-test" : td2.className = "fail-test"
        tr.append(td1, td2)
        table.append(tr)
    }
    while (testsContainer.lastChild) testsContainer.lastChild.remove()
    testsContainer.append(table)
}

function changeStatus(status, siblingBtn) {
    const statusBtn = siblingBtn.nextElementSibling
    statusBtn.firstElementChild.textContent = status
    statusBtn.firstElementChild.className = status
}