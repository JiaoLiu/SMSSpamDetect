import CreateML
import Cocoa

let data = try MLDataTable(contentsOf: URL(fileURLWithPath: "/Users/Jiao/Desktop/SecurityKeeper/SMSSpamDetect/SMSSpamCollection.csv"))
let (trainData, testData) = data.randomSplit(by: 0.8, seed: 10)
let SMSClassifier = try MLTextClassifier(trainingData: trainData, textColumn: "text", labelColumn: "label")
let trainAcc = (1 - SMSClassifier.trainingMetrics.classificationError) * 100
let validAcc = (1 - SMSClassifier.validationMetrics.classificationError) * 100

let evalMetrics = SMSClassifier.evaluation(on: testData)
let evalAcc = (1 - evalMetrics.classificationError) * 100
print(trainAcc, validAcc, evalAcc)

let metadata = MLModelMetadata(author: "Jiao", shortDescription: "SMS SPAM Detect", license: "MIT", version: "1.0", additional: nil)
try SMSClassifier.write(to: URL(fileURLWithPath: "/Users/Jiao/Desktop/SecurityKeeper/SMSSpamDetect/mlmodel/SMSClassifier.mlmodel"), metadata: metadata)

// test
let l = try SMSClassifier.prediction(from: "free phone")


