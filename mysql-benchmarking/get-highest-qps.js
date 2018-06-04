var obj = document.getElementsByClassName('singlestat-panel pointer')[0];
var currentText = obj.innerText;
var currentTextArray = currentText.split(" ");
var currentValue = currentTextArray[0];
var currentValueUnit = currentTextArray[1];
if (currentValueUnit == "K")
    currentValue *= 1000;
var maxValue = currentValue;
var maxQPS = currentText;
console.log(maxQPS);
setInterval(function() {
    obj = document.getElementsByClassName('singlestat-panel pointer')[0];
    currentText = obj.innerText;
    currentTextArray = currentText.split(" ");
    currentValue = currentTextArray[0];
    currentValueUnit = currentTextArray[1];
    if (currentValueUnit == "K")
        currentValue *= 1000;

    /* get max QPS */
    if (currentValue >= maxValue) {
        maxQPS = currentText;
        maxValue = currentValue;
    }
    console.log("current: " + currentValue);
    console.log("max: " + maxValue);
    console.log(maxQPS);
}, 3000);

// var obj = document.getElementsByClassName('singlestat-panel pointer')[0];var currentText = obj.innerText;var currentTextArray = currentText.split(" ");var currentValue = currentTextArray[0];var currentValueUnit = currentTextArray[1];if (currentValueUnit == "K")    currentValue *= 1000;var maxValue = currentValue;var maxQPS = currentText;setInterval(function() {    obj = document.getElementsByClassName('singlestat-panel pointer')[0];    currentText = obj.innerText;    currentTextArray = currentText.split(" ");    currentValue = currentTextArray[0];    currentValueUnit = currentTextArray[1];    if (currentValueUnit == "K")        currentValue *= 1000;    /* get max QPS */    if (currentValue >= maxValue) {        maxQPS = currentText;        maxValue = currentValue;    }    console.log("current: " + currentValue);    console.log("max: " + maxValue);    console.log(maxQPS);}, 3000);