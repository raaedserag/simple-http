// Import Modules
import express from "express";
import "express-async-errors"
import cors from "cors";

import landingApis from "./landing-routes.js";

const expressApi = express();
// Apply Essential Middlewares
expressApi.use(express.json({ limit: "10mb" }));
expressApi.use(express.urlencoded({ extended: true, limit: "10mb" }));
expressApi.use(cors());

// Apply Routes
Object.entries({
  "/": landingApis
}).map((route => expressApi.use(route[0], route[1])))

// Apply Error Middleware
expressApi.use((err, req, res, next) => res.status(500).send(err.message));

export default expressApi;