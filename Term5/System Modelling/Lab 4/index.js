// @ts-check

/*
 * H2 / M / 1
 */

/**
 * @typedef Job
 * @prop arrivalTime {number}
 * @prob processingTime {number}
 * @prop waitTime {number}
 */

/**
 * @typedef QueueSample
 * @prop size {number}
 * @prop time {number}
 */

/**
 * @typedef ModellingParams
 * @prop maxQueue {number}
 * @prop maxTime {number}
 * @prop loadFactorRate1 {number}
 * @prop loadFactorRate2 {number}
 * @prop loadFactorThreshold {number}
 * @prop processingRate {number}
 * @prop jobCount {number}
 */

/**
 * @typedef ModellingStats
 * @prop averageStayingTime {number}
 * @prop rejectionFrequency {number}
 * @prop averageWaitTime {number}
 * @prop averageProcessingTime {number}
 * @prop variationCoefficient {number}
 */

const jobInput = /** @type {HTMLInputElement} */ (document.querySelector("#jobInput"));
const loadFactorRate1Input = /** @type {HTMLInputElement} */ (document.querySelector("#loadFactorRate1Input"));
const loadFactorRate2Input = /** @type {HTMLInputElement} */ (document.querySelector("#loadFactorRate2Input"));
const loadFactorThresholdInput = /** @type {HTMLInputElement} */ (document.querySelector("#loadFactorThresholdInput"));
const processingFactorInput = /** @type {HTMLInputElement} */ (document.querySelector("#processingFactorInput"));
const maxQueueInput = /** @type {HTMLInputElement} */ (document.querySelector("#maxQueueInput"));
const maxTimeInput = /** @type {HTMLInputElement} */ (document.querySelector("#maxTimeInput"));
const startButton = /** @type {HTMLInputElement} */ (document.querySelector("#startButton"));
const outputParagraph = /** @type {HTMLInputElement} */ (document.querySelector("#outputParagraph"))

/**
 * @param rate {number}
 * @returns {number}
 */
const exponentialRand = (rate) => (-1 / rate) * Math.log(Math.random())

/**
 * @param rate1 {number}
 * @param rate2 {number}
 * @param threshold {number}
 * @returns {number}
 */
const hyperExponentialRand = (rate1, rate2, threshold) => 
    exponentialRand(threshold > Math.random() ? rate1 : rate2)

/**
 * @param array {number[]}
 * @returns {number}
 */
const standardDeviation = (array) => {
  const n = array.length
  const mean = array.reduce((a, b) => a + b) / n
  return Math.sqrt(array.map(x => Math.pow(x - mean, 2)).reduce((a, b) => a + b) / n)
}

/**
 * @param params {ModellingParams}
 * @returns {ModellingStats}
 */
const doModelling = (params) => {
    let rejected = 0;
    let processed = 0;
    let modellingTime = 0;
    let channelReleaseTime = 1 / 0;
    let stayingTime = 0;
    let queue = [];
    let waitTimes = [];
    let processingTimes = [];

    do {
        const arrivalTime = modellingTime + hyperExponentialRand(
            params.loadFactorRate1,
            params.loadFactorRate2,
            params.loadFactorThreshold,
        );

        if (arrivalTime > channelReleaseTime) {
            modellingTime = channelReleaseTime;
            const currentProcessingTime = exponentialRand(params.processingRate);
            processingTimes.push(currentProcessingTime);

            channelReleaseTime = queue.length == 1
                ? channelReleaseTime = 1 / 0
                : channelReleaseTime = modellingTime + currentProcessingTime;

            console.assert(queue.length > 0);
            stayingTime += (modellingTime - queue[0])

            const waitTime = Math.max(0, modellingTime - queue[0] - currentProcessingTime);
            waitTimes.push(waitTime);

            queue.splice(0, 1);

            processed++;
        } else {
            modellingTime = arrivalTime

            if (queue.length == 0) {
                const currentProcessingTime = exponentialRand(params.processingRate);
                channelReleaseTime = modellingTime + currentProcessingTime;
            }

            if (queue.length >= params.maxQueue) {
                rejected++;
            } else {
                queue.push(modellingTime);
            }
        }
    } while (modellingTime < params.maxTime && processed + rejected < params.jobCount);

    const rejectionFrequency = rejected / modellingTime;
    const averageWaitTime = waitTimes.reduce((a, b) => a + b, 0) / waitTimes.length;
    const averageProcessingTime = processingTimes.reduce((a, b) => a + b, 0) / processingTimes.length;
    const averageStayingTime = isNaN(averageWaitTime) ? averageProcessingTime : stayingTime / processed;
    const variationCoefficient = standardDeviation(processingTimes) / averageProcessingTime;

    return {
        averageStayingTime,
        rejectionFrequency,
        averageWaitTime,
        averageProcessingTime,
        variationCoefficient
    }
}


const main = () => {
    const loadFactorRate1     = parseFloat(loadFactorRate1Input.value);
    const loadFactorRate2     = parseFloat(loadFactorRate2Input.value);
    const loadFactorThreshold = parseFloat(loadFactorThresholdInput.value);
    const processingRate      = parseFloat(processingFactorInput.value);
    const maxQueue            = maxQueueInput.value ? parseFloat(maxQueueInput.value) : 1 / 0;
    const maxTime             = maxTimeInput.value ? parseFloat(maxTimeInput.value) : 1 / 0;
    const jobCount            = parseInt(jobInput.value);

    /** @type {ModellingParams} */
    const params = {
        maxQueue,
        maxTime,
        loadFactorRate1,
        loadFactorRate2,
        loadFactorThreshold,
        processingRate,
        jobCount,
    };

    const result = doModelling(params);
    outputParagraph.innerText =
        `Частота отказов: ${result.rejectionFrequency}\n` +
        `Среднее время ожидания: ${result.averageWaitTime}\n` +
        `Среднее время обслуживания: ${result.averageProcessingTime}\n` +
        `Среднее время пребывания в системе: ${result.averageStayingTime}\n` +
        `Коэффециент вариации времени обслуживания: ${result.variationCoefficient}\n`
}

// @ts-ignore
startButton.onclick = main
