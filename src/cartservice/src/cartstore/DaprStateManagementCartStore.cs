// Copyright The OpenTelemetry Authors
// SPDX-License-Identifier: Apache-2.0
using System;
using System.Linq;
using System.Threading.Tasks;
using Grpc.Core;
using Google.Protobuf;
using Microsoft.Extensions.Logging;
using Dapr.Client;

namespace cartservice.cartstore;

public class DaprStateManagementCartStore : ICartStore
{
    private readonly ILogger _logger;
    private readonly string _daprStoreName;
    private DaprClient _client;
    private readonly byte[] _emptyCartBytes;

    public DaprStateManagementCartStore(ILogger<DaprStateManagementCartStore> logger, string daprStoreName)
    {
        _logger = logger;
        _daprStoreName = daprStoreName;
        // Serialize empty cart into byte array.
        var cart = new Oteldemo.Cart();
        _emptyCartBytes = cart.ToByteArray();
    }

    public void Initialize()
    {
        if (_client is null)
            _client = new DaprClientBuilder().Build();
    }

    public async Task AddItemAsync(string userId, string productId, int quantity)
    {
        _logger.LogInformation("AddItemAsync called with userId={userId}, productId={productId}, quantity={quantity}", userId, productId, quantity);

        try
        {

            var value = await _client.GetStateAsync<byte[]>(_daprStoreName, userId.ToString());

            Oteldemo.Cart cart;
            if (value is null)
            {
                cart = new Oteldemo.Cart
                {
                    UserId = userId
                };
                cart.Items.Add(new Oteldemo.CartItem { ProductId = productId, Quantity = quantity });
            }
            else
            {
                cart = Oteldemo.Cart.Parser.ParseFrom(value);
                var existingItem = cart.Items.SingleOrDefault(i => i.ProductId == productId);
                if (existingItem == null)
                {
                    cart.Items.Add(new Oteldemo.CartItem { ProductId = productId, Quantity = quantity });
                }
                else
                {
                    existingItem.Quantity += quantity;
                }
            }
            await _client.SaveStateAsync(_daprStoreName, userId.ToString(), cart.ToByteArray());
        }
        catch (Exception ex)
        {
            throw new RpcException(new Status(StatusCode.FailedPrecondition, $"Can't access cart storage. {ex}"));
        }
    }

    public async Task EmptyCartAsync(string userId)
    {
        _logger.LogInformation("EmptyCartAsync called with userId={userId}", userId);

        try
        {
            await _client.SaveStateAsync(_daprStoreName, userId.ToString(), _emptyCartBytes);
        }
        catch (Exception ex)
        {
            throw new RpcException(new Status(StatusCode.FailedPrecondition, $"Can't access cart storage. {ex}"));
        }
    }

    public async Task<Oteldemo.Cart> GetCartAsync(string userId)
    {
        _logger.LogInformation("GetCartAsync called with userId={userId}", userId);

        try
        {

            // Access the cart from the cache
            var value = await _client.GetStateAsync<byte[]>(_daprStoreName, userId.ToString());

            if (value is not null)
            {
                return Oteldemo.Cart.Parser.ParseFrom(value);
            }

            // We decided to return empty cart in cases when user wasn't in the cache before
            return new Oteldemo.Cart();
        }
        catch (Exception ex)
        {
            throw new RpcException(new Status(StatusCode.FailedPrecondition, $"Can't access cart storage. {ex}"));
        }
    }

    public async Task<bool> PingAsync()
    {
        return await _client.CheckOutboundHealthAsync();
    }
}
