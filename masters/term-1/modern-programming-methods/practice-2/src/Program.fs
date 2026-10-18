open System
open System.Collections.Generic
open System.IO
open Microsoft.ML
open Microsoft.ML.Data

let cat name = name, DataKind.String
let num name = name, DataKind.Single

// Attributes of the UCI Statlog (German Credit) dataset, in file order.
let attributes =
    [|
        cat "Checking"; num "Duration"; cat "History"; cat "Purpose"; num "Amount"
        cat "Savings"; cat "Employment"; num "InstallmentRate"; cat "PersonalStatus"
        cat "OtherDebtors"; num "Residence"; cat "Property"; num "Age"; cat "OtherPlans"
        cat "Housing"; num "Credits"; cat "Job"; num "Dependents"; cat "Telephone"
        cat "Foreign"
    |]

let namesOf kind =
    attributes |> Array.filter (snd >> (=) kind) |> Array.map fst

let categorical = namesOf DataKind.String
let numeric = namesOf DataKind.Single

let ml = MLContext(seed = 42)

let columns =
    [|
        for i, (name, kind) in Array.indexed attributes do
            TextLoader.Column(name, kind, i)
        // 1 is a good credit risk, 2 a bad one.
        TextLoader.Column("Class", DataKind.Single, attributes.Length)
    |]

let data =
    ml.Data
        .CreateTextLoader(columns, separatorChar = ' ')
        .Load(Path.Combine(AppContext.BaseDirectory, "data", "german.data"))

let split = ml.Data.TrainTestSplit(data, testFraction = 0.2)

// The positive class is a bad credit risk, the one a lender needs to catch.
let preprocessing =
    EstimatorChain()
        .Append(
            ml.Transforms.Conversion.MapValue(
                "Label", [ KeyValuePair(1f, false); KeyValuePair(2f, true) ], "Class")
        )
        .Append(
            ml.Transforms.Categorical.OneHotEncoding
                [| for c in categorical -> InputOutputColumnPair c |]
        )
        .Append(ml.Transforms.Concatenate("Features", Array.append categorical numeric))
        .Append(ml.Transforms.NormalizeMinMax "Features")

let evaluate<'T when 'T :> ITransformer and 'T: not struct>
    (name: string)
    (trainer: IEstimator<'T>)
    =
    let model = preprocessing.Append(trainer).Fit split.TrainSet
    let m = ml.BinaryClassification.Evaluate(model.Transform split.TestSet)

    printfn $"== {name}"
    printfn $"Accuracy  {m.Accuracy:F3}"
    printfn $"Precision {m.PositivePrecision:F3}"
    printfn $"Recall    {m.PositiveRecall:F3}"
    printfn $"F1        {m.F1Score:F3}"
    printfn $"ROC AUC   {m.AreaUnderRocCurve:F3}"
    printfn $"{m.ConfusionMatrix.GetFormattedConfusionTable()}"

let rows (view: IDataView) =
    view.GetColumn<float32> "Class" |> Seq.length

printfn $"Train: {rows split.TrainSet}, test: {rows split.TestSet}\n"

evaluate "Logistic regression" (ml.BinaryClassification.Trainers.LbfgsLogisticRegression())

evaluate
    "Gradient-boosted trees"
    (ml.BinaryClassification.Trainers.FastTree(numberOfTrees = 100, numberOfLeaves = 8))
