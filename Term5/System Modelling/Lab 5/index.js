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
 * @typedef State
 * @prop jobs {Job[]}
 * @prop queue {Job[]}
 * @prop queueSamples {QueueSample[]}
 */

const jobInput = document.querySelector("#jobInput");
const loadFactorInput = document.querySelector("#loadFactorInput");
const processingFactorInput = document.querySelector("#processingFactorInput");
const startButton = document.querySelector("#startButton");

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
 * @param state {State}
 */
const evaluateState = (state) => {
    state = structuredClone(state)

    const queueSamples = []

    while (state.queue.length > 0 || state.jobs.length > 0) {
        state.jobs.pop();
    }

    return { queueSamples }
}


const main = () => {
    // @ts-ignore
    const loadFactor = parseFloat(loadFactorInput.value);
    // @ts-ignore
    const processingFactor = parseFloat(processingFactorInput.value);
    // @ts-ignore
    const jobCount = parseInt(jobInput.value);

    /** @type {Job[]} */
    const jobs = Array(jobCount)
    .fill(undefined)
    .map((_) => {
        return {
            arrivalTime: exponentialRand(loadFactor),
            processingTime: exponentialRand(processingFactor),
            waitTime: 0,
        }
    })

    /** @type {State} */
    const initialState = {
        jobs,
        queue: [],
        queueSamples: [],
    };

    const result = evaluateState(initialState);
    console.log(result)
}

// @ts-ignore
startButton.onclick = main

/*

    const getProcessedJobs = (remainingTime, queue, processed = 0, processingTime = 0) => {
        const timeToProcess = exponentialRand(processingFactor);

        if (queue == 0) {
            return { remainingTime: 0, processed, processingTime}
        } else if (timeToProcess > remainingTime) {
            return { remainingTime, processed, processingTime }
        } else {
            return getProcessedJobs(remainingTime - timeToProcess, queue - 1, processed + 1, processingTime + timeToProcess);
        }
    }

    const nextState = (state, job) => {
        const queue = state.queue + 1;
        const processedJobs = job > state.remainingProcessingTime
            ? getProcessedJobs(job - state.remainingProcessingTime, queue)
            : {
                remainingTime: state.remainingProcessingTime - job,
                processed: 0,
                processingTime: job,
            };

        return {
            queue: queue - processedJobs.processed,
            remainingProcessingTime: processedJobs.remainingTime,
            waitTime: state.waitTime,
            processingTime: state.processingTime + processedJobs.processingTime,
        }
    };

    const finalizeState = (state) => {
        const remainingQueueProcessingTime = Array(state.queue)
            .fill(processingFactor)
            .map(exponentialRand)
            .reduce((a, b) => a + b, 0);

        return {
            queue: 0,
            remainingProcessingTime: 0,
            waitTime: state.waitTime,
            processingTime: state.processingTime + remainingQueueProcessingTime + state.remainingProcessingTime,
        }
    }
*/
