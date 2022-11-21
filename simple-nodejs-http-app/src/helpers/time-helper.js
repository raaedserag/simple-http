export function getCurrentTime(timeZone) {
    return new Date().toLocaleString("en-US", { timeZone });
}