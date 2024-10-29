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
 * @prop loadRate {number}
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

const jobInput = document.querySelector("#jobInput");
const loadFactorInput = document.querySelector("#loadFactorInput");
const processingFactorInput = document.querySelector("#processingFactorInput");
const startButton = document.querySelector("#startButton");
const outputParagraph = document.querySelector("#outputParagraph")

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
        const arrivalTime = modellingTime + exponentialRand(params.loadRate);

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

    const averageStayingTime = stayingTime / processed;
    const rejectionFrequency = rejected / modellingTime;
    const averageWaitTime = waitTimes.reduce((a, b) => a + b, 0) / waitTimes.length;
    const averageProcessingTime = processingTimes.reduce((a, b) => a + b, 0) / processingTimes.length;
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
    // @ts-ignore
    const loadRate = parseFloat(loadFactorInput.value);
    // @ts-ignore
    const processingRate = parseFloat(processingFactorInput.value);
    // @ts-ignore
    const jobCount = parseInt(jobInput.value);

    /** @type {ModellingParams} */
    const params = {
        maxQueue: 1000,
        maxTime: 1000,
        loadRate,
        processingRate,
        jobCount,
    };

    const result = doModelling(params);
    // @ts-ignore
    outputParagraph.innerText =
        `Среднее время пребывания в системе: ${result.averageStayingTime}\n` +
        `Частота отказов: ${result.rejectionFrequency}\n` +
        `Среднее время ожидания: ${result.averageWaitTime}\n` +
        `Среднее время обслуживания: ${result.averageProcessingTime}\n` +
        `Коэффециент вариации времени обслуживания: ${result.variationCoefficient}\n`
}

// @ts-ignore
startButton.onclick = main
