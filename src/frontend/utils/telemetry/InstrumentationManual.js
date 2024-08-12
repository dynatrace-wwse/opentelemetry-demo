// Copyright The OpenTelemetry Authors
// SPDX-License-Identifier: Apache-2.0

const opentelemetry = require('@opentelemetry/sdk-node');
const {OTLPTraceExporter} = require('@opentelemetry/exporter-trace-otlp-http');
const {alibabaCloudEcsDetector} = require('@opentelemetry/resource-detector-alibaba-cloud');
const {awsEc2Detector, awsEksDetector} = require('@opentelemetry/resource-detector-aws');
const {containerDetector} = require('@opentelemetry/resource-detector-container');
const {gcpDetector} = require('@opentelemetry/resource-detector-gcp');
const {envDetector, hostDetector, osDetector, processDetector} = require('@opentelemetry/resources');

const sdk = new opentelemetry.NodeSDK({
  traceExporter: new OTLPTraceExporter(),
  resourceDetectors: [
    containerDetector,
    envDetector,
    hostDetector,
    osDetector,
    processDetector,
    alibabaCloudEcsDetector,
    awsEksDetector,
    awsEc2Detector,
    gcpDetector,
  ],
});

sdk.start();
