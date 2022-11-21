import {getCurrentTime} from "../src/helpers/time-helper.js";

describe("Get Current Time Tests", () => {
  test('Get current time without passing parameter should return local server time', () => {
    const realCurrentServerTime = new Date().toLocaleString()
    const testedCurrentServerTime = getCurrentTime()
    expect(testedCurrentServerTime).toBe(realCurrentServerTime);
  });
  test('Get current time while passing UTC as a time zone should return server UTC time', ()=>{
    const realCurrentServerTime = new Date().toLocaleString("en-US", { timeZone: "UTC" })
    const testedCurrentServerTime = getCurrentTime("UTC")
    expect(testedCurrentServerTime).toBe(realCurrentServerTime);
  })
    test('Get current time while passing Africa/Cairo as a time zone should return server Egypt time', ()=>{
    const realCurrentServerTime = new Date().toLocaleString("en-US", { timeZone: "Africa/Cairo" })
    const testedCurrentServerTime = getCurrentTime("Africa/Cairo")
    expect(testedCurrentServerTime).toBe(realCurrentServerTime);
  })
  
})