// Copyright The OpenTelemetry Authors
// SPDX-License-Identifier: Apache-2.0

using AccountingService;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using CloudNative.CloudEvents.AspNetCore;
using Microsoft.AspNetCore.HttpLogging;
using Dapr;
using Dapr.Client;
using Oteldemo;

Console.WriteLine("Accounting service started");

Environment.GetEnvironmentVariables()
    .FilterRelevant()
    .OutputInOrder();

var builder = WebApplication.CreateBuilder(args);
// This is the Original Kafka Consumer Code before Dapr
// builder.services.AddSingleton<Consumer>();

builder.Logging.ClearProviders();
builder.Logging.AddConsole();
builder.Services.AddHttpLogging(httpLoggingOptions =>
{
    httpLoggingOptions.LoggingFields =
        HttpLoggingFields.RequestPath |
        HttpLoggingFields.RequestMethod |
        HttpLoggingFields.ResponseStatusCode |
        HttpLoggingFields.RequestBody;
});

var app = builder.Build();

app.UseHttpLogging();
app.UseRouting();

// Dapr configurations
app.UseCloudEvents();

app.MapSubscribeHandler();

app.MapPost("/orders", [Topic("pubsub", "orders")] (ILogger<Program> logger, [FromBody] Stream stream) =>
{
    if (stream is not null &&
        stream is MemoryStream)
    {
        var bytes = ((MemoryStream)stream).ToArray();
        if (bytes.Length > 0)
        {
            try
            {
                var order = OrderResult.Parser.ParseFrom(bytes);

                Log.OrderReceivedMessage(logger, order);
            }
            catch (Exception ex)
            {
                logger.LogError(ex, "Order parsing failed:");
            }
            return Results.Ok();
        }
    }

    return Results.BadRequest();
});


//TODO: Put original Kafka Consumer Code behind feature flag
/* var consumer = host.Services.GetRequiredService<Consumer>();
consumer.StartListening(); */

app.Run();