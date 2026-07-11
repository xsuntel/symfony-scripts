---
paths:
  - "app/src/ApiResource/**/*.php"
---

# External API Integration Rules

This rule applies to all code that communicates with third-party APIs (KoreaInvestment, UPbit, VWorld, etc.).

## Using HttpClient

- Always use `Symfony\Contracts\HttpClient\HttpClientInterface` — do not use `curl`, `file_get_contents`, or Guzzle directly.
- Inject it via the constructor — do not instantiate `HttpClient::create()` directly inside a Service.
- Configure a named HTTP client per external provider in `config/packages/framework.yaml` (`framework.http_client.scoped_clients`) — do not share one client across multiple providers.
- Set `timeout`, `max_redirects`, and `verify_peer` explicitly on named clients — do not rely on the defaults.

## API Key Management

- Store KoreaInvestment and UPbit API keys in **encrypted** JSONB columns (`app_key`, `secret_key`) in the database — do not store per-user keys in environment variables.
- Store application-level (system-wide) API keys in environment variables (`APP_KOREA_INVESTMENT_KEY`, etc.) — do not hardcode them in PHP files.
- Keep decryption logic in a dedicated `Service/{Provider}/ApiKeyService` class — Controllers and Handlers must never decrypt directly.
- Never log the decrypted API key value — log only a masked key prefix (first 4 characters + `****`).
- Use `#[Sensitive]` on DTO properties that hold API keys or secret values.

## Authentication Token / Key Lifecycle (common)

- Store and reuse issued authentication tokens (OAuth2 access tokens, WebSocket approval keys, etc.) in Redis with a TTL equal to the response's expiry value (`expires_in`, etc.).
- Handle token refresh in the `EventSubscriber` layer — not in a Service or Controller.
- Do not cache tokens in the PHP session — Redis is the only permitted token store.
- On logout/revocation, revoke the token via a Messenger Command dispatched asynchronously.
- For providers that rate-limit issuance itself, reusing the stored token is the default — no repeated short-interval issuance.

## Response Persistence Pattern

Persist API responses received from financial/real-estate providers in the database in their original JSON form:

1. Fetch the response with HttpClient in a `MessageCommandHandler`.
2. Deserialize it into a provider-specific DTO with the Symfony Serializer.
3. Persist the original payload to the corresponding `Entity` (JSON/JSONB column).
4. Dispatch a `MessageEvent` to trigger downstream processing.

Do not transform or aggregate provider data inside the same handler that fetches the response — separate fetch from transform.

## Error Handling

- Catch network failures with `Symfony\Contracts\HttpClient\Exception\TransportExceptionInterface`.
- Catch 4xx/5xx responses with `Symfony\Contracts\HttpClient\Exception\HttpExceptionInterface`.
- Re-throw transient failures (503, timeout) as `\RuntimeException` — the RabbitMQ transport retries up to the configured `max_retries`.
- For permanent failures (401, 403), dispatch a `MessageEvent` that notifies the owning user via Symfony Notifier — do not retry.
- Do not silently swallow exceptions in provider integration code.

## Holiday and Business-Day Handling (common)

- Use `azuyalabs/yasumi` to compute Korean public holidays — do not hardcode holiday dates.
- The source of truth for market holidays is the provider's holiday endpoint — sync it via the Scheduler and store results in the `ChkHoliday` entity. See the provider rule for endpoint details (e.g. KoreaInvestment `chk-holiday`).
- Business-day checks must consult both Yasumi and the `ChkHoliday` entity — if either one flags a non-business day, treat it as a non-business day.

## WebSocket (Ratchet/Pawl) (common)

- Use `ratchet/pawl`-based outbound WebSocket connections for provider real-time data streams.
- Do not open a WebSocket connection within a synchronous HTTP request cycle — always dispatch a Command so an async worker manages the connection.
- WebSocket state (connection handles, subscription lists) must be stored in Redis, not in PHP memory or static properties.
- Provider-specific details such as subscription format, authentication (approval key/JWT), and reconnection policy follow each provider's `api-websocket-rule.md`.

## Rate-Limit Awareness (common)

- External REST APIs have per-second/per-minute/per-day rate limits — enforce them with Symfony Lock (`symfony/lock`) before dispatching consecutive HTTP requests.
- Use a per-endpoint/group sliding-window lock key: `lock_{provider}_{endpoint_or_group}` (e.g. `lock_korea_investment_{tr_id}`).
- Do not batch API calls in a tight loop without a lock-protected throttling strategy.
- Provider-specific limit values and grouping rules follow each provider's `api-rest-rule.md`.

## Scheduler Integration

- Annotate each task class with `#[AsPeriodicTask(frequency: '...', jitter: N)]` — one class per recurring task.
- Scheduler tasks dispatch a MessageCommand via `MessageBusInterface` — they do not call a Service or Repository directly.
- Market-time-sensitive tasks must check `ChkHoliday` before running — place this guard inside the `MessageCommandHandler`, not in the Scheduler class.
